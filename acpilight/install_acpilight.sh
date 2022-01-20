package=light
if pacman -Qs $package > /dev/null ; then
  echo "the package $package is installed"
else
  echo "the package $package is not installed"
  pacman -Sy $package
fi

package=acpilight
if pacman -Qs $package > /dev/null ; then
  echo "the package $package is installed"
else
  echo "the package $package is not installed"
  pacman -Sy $package
fi

sudo stow rules.d -d etc/udev/ -t /etc/udev/rules.d/stow -t /etc/
sudo udevadm control --reload