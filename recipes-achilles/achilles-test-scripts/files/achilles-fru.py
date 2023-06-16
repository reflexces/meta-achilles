# Copyright 2023 reflex ces <www.reflexces.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS”
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

import argparse
import datetime
import pathlib

from enum import IntEnum
from typing import Tuple


def compute_zero_checksum(data: bytes) -> int:
    sum = 0
    for byte in data:
        sum += byte
        sum = sum & 0xFF

    return sum


class FruType(IntEnum):
    BINARY = 0
    BCD = 1
    CHAR6 = 2
    CHAR8 = 3


class FruTypeLength:
    def __init__(self, data: int) -> None:
        self.__length = data & 0x3F
        self.__field_type = FruType((data >> 6) & 0x03)

    @property
    def length(self) -> int:
        return self.__length

    @length.setter
    def length(self, len: int):
        self.__length = len & 0x3F

    @property
    def field_type(self) -> FruType:
        return self.__field_type

    @field_type.setter
    def field_type(self, ftype: FruType):
        self.__field_type = ftype

    @property
    def value(self) -> int:
        return (self.__length & 0x3F) | ((self.__field_type << 6) & 0xC0)


def field_to_str(ftype: FruType, data: bytes, lcode: int):
    field_str = ""
    if ftype == FruType.CHAR8:
        if lcode == 0:
            field_str = data.decode('latin_1')
        else:
            field_str = data.decode('utf_16_le')
    elif ftype == FruType.CHAR6:
        raise Exception("Unimplemented")
    elif ftype == FruType.BCD:
        raise Exception("Unimplemented")

    return field_str


class FruAreaBoardInfo:
    __stop_typelength = FruTypeLength(0xC1)

    def __init__(self) -> None:
        self.__format_version = 1
        self.__language_code = 0
        self.__mfg_datetime_data = bytearray(3)

        self.__mfr_typelength = FruTypeLength(0)
        self.__mfr_data = bytearray()

        self.__product_typelength = FruTypeLength(0)
        self.__product_data = bytearray()

        self.__serial_typelength = FruTypeLength(0)
        self.__serial_data = bytearray()

        self.__part_typelength = FruTypeLength(0)
        self.__part_data = bytearray()

        self.__file_id_typelength = FruTypeLength(0)
        self.__file_id_data = bytearray()

    @property
    def area_length_bytes(self) -> int:
        area_length = 3 + len(self.__mfg_datetime_data) \
                        + 1 + len(self.__mfr_data) \
                        + 1 + len(self.__product_data) \
                        + 1 + len(self.__serial_data) \
                        + 1 + len(self.__part_data) \
                        + 1 + len(self.__file_id_data) \
                        + 2

        blank_bytes = area_length % 8
        if blank_bytes != 0:
            blank_bytes = 8 - blank_bytes
        area_length += blank_bytes

        return area_length

    @property
    def area_length(self) -> int:
        return int(self.area_length_bytes / 8)

    @property
    def language(self) -> int:
        return self.__language_code

    @property
    def mfg_datetime(self) -> datetime.datetime:
        data = self.__mfg_datetime_data
        mfg_minutes = data[0] + (data[1] << 8) + (data[2] << 16)
        return datetime.datetime(1996, 1, 1) + datetime.timedelta(minutes=mfg_minutes)

    @mfg_datetime.setter
    def mfg_datetime(self, dt: datetime.datetime):
        if dt < datetime.datetime(1996, 1, 1):
            raise ValueError

        mfg_timedelta = dt - datetime.datetime(1996, 1, 1)
        mfg_minutes = round(mfg_timedelta.total_seconds() / 60)

        self.__mfg_datetime_data[0] = mfg_minutes & 0xFF
        self.__mfg_datetime_data[1] = (mfg_minutes >> 8) & 0xFF
        self.__mfg_datetime_data[2] = (mfg_minutes >> 16) & 0xFF

    @property
    def manufacturer(self) -> Tuple[FruType, bytes]:
        return (self.__mfr_typelength.field_type, self.__mfr_data)

    def set_manufacturer(self, ft: FruType, name: bytes):
        if len(name) > 0x3F:
            raise ValueError

        self.__mfr_data = bytearray(name)
        self.__mfr_typelength.field_type = ft
        self.__mfr_typelength.length = len(self.__mfr_data)

    @property
    def product_name(self) -> Tuple[FruType, bytes]:
        return (self.__product_typelength.field_type, self.__product_data)

    def set_product_name(self, ft: FruType, name: bytes):
        if len(name) > 0x3F:
            raise ValueError

        self.__product_data = bytearray(name)
        self.__product_typelength.field_type = ft
        self.__product_typelength.length = len(self.__product_data)

    @property
    def product_number(self) -> Tuple[FruType, bytes]:
        return (self.__part_typelength.field_type, self.__part_data)

    def set_product_number(self, ft: FruType, pn: bytes):
        if len(pn) > 0x3F:
            raise ValueError

        self.__part_data = bytearray(pn)
        self.__part_typelength.field_type = ft
        self.__part_typelength.length = len(self.__part_data)

    @property
    def serial_number(self) -> Tuple[FruType, bytes]:
        return (self.__serial_typelength.field_type, self.__serial_data)

    def set_serial_number(self, ft: FruType, sn: bytes):
        if len(sn) > 0x3F:
            raise ValueError

        self.__serial_data = bytearray(sn)
        self.__serial_typelength.field_type = ft
        self.__serial_typelength.length = len(self.__serial_data)

    @property
    def fiel_id(self) -> Tuple[FruType, bytes]:
        return (self.__serial_typelength.field_type, self.__serial_data)

    def into_bytearray(self) -> bytearray:
        data = bytearray()

        data.append(self.__format_version)
        data.append(self.area_length)
        data.append(self.__language_code)
        data.extend(self.__mfg_datetime_data)

        data.append(self.__mfr_typelength.value)
        data.extend(self.__mfr_data)

        data.append(self.__product_typelength.value)
        data.extend(self.__product_data)

        data.append(self.__serial_typelength.value)
        data.extend(self.__serial_data)

        data.append(self.__part_typelength.value)
        data.extend(self.__part_data)

        data.append(self.__file_id_typelength.value)
        data.extend(self.__file_id_data)

        data.append(self.__stop_typelength.value)

        padding = (self.area_length_bytes - 1) - len(data)
        data.extend(bytearray(padding))

        checksum_value = 256 - compute_zero_checksum(data)
        data.append(checksum_value)

        return data

    def from_bytes(self, data: bytes):
        if compute_zero_checksum(data) != 0:
            raise ValueError

        self.__format_version = data[0] & 0x0F
        area_length = data[1]
        area_length_bytes = data[1] * 8

        self.__language_code = data[2]
        self.__mfg_datetime_data = bytearray(data[3:6])

        mfr_offset = 6
        self.__mfr_typelength = FruTypeLength(data[mfr_offset])
        if self.__mfr_typelength.length != 0:
            self.__mfr_data = bytearray(data[mfr_offset+1:mfr_offset+1+self.__mfr_typelength.length])

        product_offset = 6 + 1 + self.__mfr_typelength.length
        self.__product_typelength = FruTypeLength(data[product_offset])
        if self.__product_typelength.length != 0:
            self.__product_data = bytearray(data[product_offset+1:product_offset+1+self.__product_typelength.length])

        serial_offset = product_offset + 1 + self.__product_typelength.length
        self.__serial_typelength = FruTypeLength(data[serial_offset])
        if self.__serial_typelength.length != 0:
            self.__serial_data = bytearray(data[serial_offset+1:serial_offset+1+self.__serial_typelength.length])

        part_offset = serial_offset + 1 + self.__serial_typelength.length
        self.__part_typelength = FruTypeLength(data[part_offset])
        if self.__part_typelength.length != 0:
            self.__part_data = bytearray(data[part_offset+1:part_offset+1+self.__part_typelength.length])

        file_id_offset = part_offset + 1 + self.__part_typelength.length
        self.__file_id_typelength = FruTypeLength(data[file_id_offset])
        if self.__file_id_typelength.length != 0:
            self.__file_id_data = bytearray(data[file_id_offset+1:file_id_offset+1+self.__file_id_typelength.length])

    def print_info(self, lp: str):
        print(f"{lp}Board manufacturer: {field_to_str(*self.manufacturer, self.language)}")
        print(f"{lp}Board product name: {field_to_str(*self.product_name, self.language)}")
        print(f"{lp}Board product number: {field_to_str(*self.product_number, self.language)}")
        print(f"{lp}Board serial number: {field_to_str(*self.serial_number, self.language)}")
        print(f"{lp}Board manufacturing datetime: {self.mfg_datetime.isoformat(sep=' ')}")


class FruStorage:
    __header_length = 1
    __header_length_bytes = __header_length * 8

    def __init__(self) -> None:
        self.__format_version = 1

        self.area_board_info = FruAreaBoardInfo()

        self.__offset_area_internal_use = 0
        self.__offset_area_chassis_info = 0
        self.__offset_area_board_info = self.__header_length
        self.__offset_area_product_info = 0
        self.__offset_area_multirecord = 0

    def into_bytearray(self):
        data = bytearray()

        data.append(self.__format_version)
        data.append(self.__offset_area_internal_use)
        data.append(self.__offset_area_chassis_info)
        data.append(self.__offset_area_board_info)
        data.append(self.__offset_area_product_info)
        data.append(self.__offset_area_multirecord)
        data.append(0)
        data.append(256 - compute_zero_checksum(data))

        data.extend(self.area_board_info.into_bytearray())

        return data

    def from_bytes(self, data: bytes):
        self.__format_version = data[0]
        self.__offset_area_internal_use = data[1]
        self.__offset_area_chassis_info = data[2]
        self.__offset_area_board_info = data[3]
        self.__offset_area_product_info = data[4]
        self.__offset_area_multirecord = data[5]

        if self.__offset_area_board_info != 0:
            offset = self.__offset_area_board_info * 8
            area_length = data[offset + 1] * 8
            self.area_board_info.from_bytes(data[offset:offset+area_length])

    def print_info(self):
        if self.__offset_area_board_info != 0:
            print("Board info:")
            self.area_board_info.print_info("  ")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--file', type=pathlib.Path, required=True,
                        help="")
    subparsers = parser.add_subparsers(dest='cmd', help='Sub-command help')

    parser_set = subparsers.add_parser('set', help='Set the FRU fields into the file, old value are erased')
    parser_set.add_argument('-s', '--serial', type=str, required=True,
                            help="Board serial number")
    parser_set.add_argument('-p', '--product', type=str, required=True,
                            help="Board product number")
    parser_set.add_argument('-m', '--manufacturer', type=str,
                            help="Board manufacturer")
    parser_set.add_argument('-n', '--name', type=str,
                            help="Board product name")
    parser_set.add_argument('-d', '--datetime', type=datetime.datetime.fromisoformat,
                            help="Board manufacturing datetime (ISO 8601)")

    parser_get = subparsers.add_parser('get', help='Get the FRU from the file')

    args = parser.parse_args()

    fru_storage = FruStorage()

    if args.cmd == 'set':
        if args.serial is not None:
            fru_storage.area_board_info.set_serial_number(FruType.CHAR8, args.serial.encode('latin_1'))
        if args.product is not None:
            fru_storage.area_board_info.set_product_number(FruType.CHAR8, args.product.encode('latin_1'))
        if args.manufacturer is not None:
            fru_storage.area_board_info.set_manufacturer(FruType.CHAR8, args.manufacturer.encode('latin_1'))
        if args.name is not None:
            fru_storage.area_board_info.set_product_name(FruType.CHAR8, args.name.encode('latin_1'))
        if args.datetime is not None:
            fru_storage.area_board_info.mfg_datetime = args.datetime

        with open(args.file, "wb") as f:
            f.write(fru_storage.into_bytearray())
    elif args.cmd == 'get':
        with open(args.file, "rb") as f:
            data = f.read()
            fru_storage.from_bytes(data)

            fru_storage.print_info()


if __name__ == "__main__":
    main()
