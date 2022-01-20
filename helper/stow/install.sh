package=acpilight
if pacman -Qs $package > /dev/null ; then
  echo "The package $package is installed"
else
  echo "The package $package is not installed"
  pacman -Sy $package
fi

mkdir a/b/c 
mkdir c/d/e 
echo test > c/d/e/test.txt
stow c -t a/b/c # this will take d/e in to a/b/c/  , default dir is current directory
# target -t 
# dir -d set the dir that you want, but will need to be one level above
stow e -t a/b/c -d c/d # you will need at least a folder to work
