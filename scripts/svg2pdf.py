#!/usr/bin/env python3
"""Convert SVG figures to vector PDF using librsvg + cairo.

Usage: svg2pdf.py INPUT.svg OUTPUT.pdf

Requires the system packages providing PyGObject with Rsvg 2.0 and pycairo
(on Debian/Ubuntu: python3-gi, python3-gi-cairo, gir1.2-rsvg-2.0).
Falls back to `rsvg-convert` or `inkscape` if they are on PATH.
"""

import shutil
import subprocess
import sys


def convert_with_gi(src: str, dst: str) -> None:
    import gi

    gi.require_version("Rsvg", "2.0")
    import cairo
    from gi.repository import Rsvg

    handle = Rsvg.Handle.new_from_file(src)
    has_size, width, height = handle.get_intrinsic_size_in_pixels()
    if not has_size:
        dims = handle.get_dimensions()
        width, height = dims.width, dims.height

    # librsvg reports sizes in CSS pixels (96 dpi); PDF uses points (72 dpi).
    scale = 72.0 / 96.0
    surface = cairo.PDFSurface(dst, width * scale, height * scale)
    # Fixed dates keep the output byte-identical between builds.
    surface.set_metadata(cairo.PDF_METADATA_CREATE_DATE, "2024-01-01T00:00:00Z")
    surface.set_metadata(cairo.PDF_METADATA_MOD_DATE, "2024-01-01T00:00:00Z")
    ctx = cairo.Context(surface)
    ctx.scale(scale, scale)
    viewport = Rsvg.Rectangle()
    viewport.x, viewport.y, viewport.width, viewport.height = 0, 0, width, height
    handle.render_document(ctx, viewport)
    surface.finish()


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        return 2
    src, dst = sys.argv[1], sys.argv[2]

    try:
        convert_with_gi(src, dst)
        return 0
    except (ImportError, ValueError) as exc:
        gi_error = exc

    if shutil.which("rsvg-convert"):
        return subprocess.call(["rsvg-convert", "-f", "pdf", "-o", dst, src])
    if shutil.which("inkscape"):
        return subprocess.call(["inkscape", src, "--export-type=pdf", f"--export-filename={dst}"])

    print(f"svg2pdf: no converter available ({gi_error})", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
