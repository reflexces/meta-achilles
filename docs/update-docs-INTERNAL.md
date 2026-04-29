# Updating Documentation for Achilles SoC SOM

## ⚠️ This is indended for internal reflex ces use only. ⚠️

This guide explains how to update documentation in the `reflexces/meta-achilles` repository and deploy changes to GitHub Pages.

## Prerequisites
- Python 3.6+ installed (`python3 --version`)
- Git installed and configured with GitHub access (`git --version`)
- Push permissions to the `reflexces/meta-achilles` repository

## Steps to Update Documentation

### 1. Clone the Repository and Checkout docs Branch

```bash
git clone https://github.com/reflexces/meta-achilles.git
cd meta-achilles
git checkout docs
```

### 2. Install MkDocs and Required Extensions

Try global install first:

```bash
pip3 install mkdocs pymdown-extensions
```

If you get the error "externally-managed-environment", use a virtual environment:

```bash
python3 -m venv mkdocs-venv
source mkdocs-venv/bin/activate
pip install mkdocs pymdown-extensions
```

Verify installation:

```bash
mkdocs --version
```

All remaining commands below will be run from your main global console prompt, or from the virtual environment if the global install failed.  Commands should be run from /meta-achilles path after checking out the **docs** branch.

### 3. Edit Documentation

Edit the relevant .md file with your preferred text editor:

```bash
gedit docs/index.md
```

Tips:
- Use 4 spaces for sub-bullets (important for proper rendering)
- Use correct image paths, e.g. images/achilles_design_flow_gsrd_2022.06.png
- Maintain header consistency (# for titles, ## for sections)

### 4. Test Changes Locally

```bash
mkdocs build --clean
mkdocs serve
```

Open http://127.0.0.1:8000 in your browser and verify the changes.  If it is necessary to iterate changes, use Ctrl-C to stop `mkdocs serve`, edit the file again, then repeat the two steps above.

### 5. Commit Changes

```bash
git add docs/your-edited-file.md
git commit -m "Fix formatting on XYZ page"
git push origin docs
```

### 6. Deploy to GitHub Pages

```bash
mkdocs gh-deploy --force
```

This updates the live site at: https://reflexces.github.io/meta-achilles/

Each time a change is made locally and then pushed, the above command must be run again.

### 7. Verify Live Site

Go to https://reflexces.github.io/meta-achilles/ and confirm your changes appear correctly (updates can take several minutes to be visible).

## Notes
- Only commit source files (.md, .yml, .css, images). Do not commit the `site` folder or `mkdocs-venv` folder if working in virtual environment (these 2 folders are ignored in the .gitignore file).
- Image file names should not contain spaces.
