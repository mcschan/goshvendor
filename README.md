# Introduction
This is a simple bash script for managing Go vendor libraries.  Use this script to vendor your libraries if you don't want the libraries as git submodules.  That way, you can actually commit the source of the libraries into your repo.  The script does this by renmaing the `.git` folder to `.checkout_git`.

# Installation
`git clone` this repo or copy and paste the `vendor.sh` script into your `vendor/` directory.

# Usage

Instead of using `go get`, you run the script instead.

```
cd path/to/my/repo
./vendor/vendor.sh {package}
```

## Example
`./vendor/vendor.sh golang.org/x/tools/cmd/goimports`

This is the resulting file structure in `vendor/`

```
path/to/my/repo
--- vendor/
------ vendor.sh
------ golang.org -> src/golang.org (symlink)
------ src/
--------- golang.org/x/tools/cmd/goimports
------ pkg/
--------- ...
```

# How it works
1. Change the GOPATH temporarily to the `vendor/` directory
2. Rename the `.checkout_git` directories to `.git`
3. Go get the package
4. Rename the `.git` directories back to `.checkout_git`
5. Create a symlink to the directory of the library