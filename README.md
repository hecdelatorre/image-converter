# Image Converter

This script is a simple tool for converting images to different formats using ImageMagick and other dependencies.

## Dependencies

To use this script, you need the following dependencies installed:

- [fzf](https://github.com/junegunn/fzf): A command-line fuzzy finder.
- [potrace](http://potrace.sourceforge.net/): Transforming a bitmap image into a smooth, scalable image.
- [WebP](https://developers.google.com/speed/webp/docs/compiling): A modern image format that provides superior compression for web images.
- [ImageMagick](https://imagemagick.org/index.php): A powerful command-line tool for image processing.

### Installing Dependencies

#### Debian/Ubuntu

```bash
sudo apt install fzf potrace webp imagemagick
```

#### Fedora

```bash
sudo dnf install fzf potrace webp imagemagick
```

#### Arch Linux

```bash
sudo pacman -Sy fzf potrace webp imagemagick
```

## Running the Script

You can run the script using the following command:

```bash
bash -c "$(curl -fsSL https://codeberg.org/hecdelatorre/image-converter/raw/branch/main/image_converter.sh)"
```

This command will clone the repository and execute the `image_converter.sh` script. Make sure you have all the dependencies installed before running the script.

## License

This script is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
