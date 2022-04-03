package=python
if pacman -Qs $package > /dev/null ; then
  echo "The package $package is installed"
else
  echo "The package $package is not installed"
  pacman -Sy python
fi
package=pip
if pacman -Qs $package > /dev/null ; then
  echo "The package $package is installed"
else
  echo "The package $package is not installed"
  pacman -Sy pip
fi
pip install virtualenv
pip install kaggle