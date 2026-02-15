{pkgs, ...}: {
	environment.pathsToLink = [
		"share/thumbnailers"
	];

	environment.systemPackages = with pkgs; [
		# Video

		ffmpegthumbnailer

		# Images

		gdk-pixbuf
		# HEIF + AVIF
		libheif.bin
		libheif.out
		# Newer AVIF
		libavif
		# JXL (JPEG XL)
		libjxl
		# WebP
		webp-pixbuf-loader
	];
}
