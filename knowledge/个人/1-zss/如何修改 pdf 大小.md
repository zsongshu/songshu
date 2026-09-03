---
title: "如何修改 pdf 大小"
source: "如何修改 pdf 大小.docx"
type: docx
tags: ["docx"]
path: "1-zss"
created: 2026-07-03
---

# 如何修改 pdf 大小

![[如何修改 pdf 大小-5d04a99c.docx]]

## 内容

+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| #!/bin/bash                                                                                                                                                                               |
|                                                                                                                                                                                           |
| \# 合法值只有 5 个宏：/screen, /ebook, /printer, /prepress, /default，分别对应约 72 dpi、150 dpi、300 dpi、300+ dpi。                                                                     |
|                                                                                                                                                                                           |
| \# /bin/bash -c \"\$(curl -fsSL [[https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh]{.underline}](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))\" |
|                                                                                                                                                                                           |
| \# brew install ghostscript                                                                                                                                                               |
|                                                                                                                                                                                           |
| \# ./gs.sh \~/Downloads/example.pdf                                                                                                                                                       |
|                                                                                                                                                                                           |
| dpi=46                                                                                                                                                                                    |
|                                                                                                                                                                                           |
| quality=70                                                                                                                                                                                |
|                                                                                                                                                                                           |
| outfile=\"\${1%.\*}\_\${dpi}q\${quality}.pdf\"                                                                                                                                            |
|                                                                                                                                                                                           |
| gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \\                                                                                                                                              |
|                                                                                                                                                                                           |
|    -sOutputFile=\"\$outfile\" \\                                                                                                                                                          |
|                                                                                                                                                                                           |
|    -dCompatibilityLevel=1.4 \\                                                                                                                                                            |
|                                                                                                                                                                                           |
|    -dPDFSETTINGS=/screen \\                                                                                                                                                               |
|                                                                                                                                                                                           |
|    -dColorImageResolution=\$dpi \\                                                                                                                                                        |
|                                                                                                                                                                                           |
|    -dGrayImageResolution=\$dpi \\                                                                                                                                                         |
|                                                                                                                                                                                           |
|    -dMonoImageResolution=\$dpi \\                                                                                                                                                         |
|                                                                                                                                                                                           |
|    -dDownsampleColorImages=true \\                                                                                                                                                        |
|                                                                                                                                                                                           |
|    -dDownsampleGrayImages=true \\                                                                                                                                                         |
|                                                                                                                                                                                           |
|    -dDownsampleMonoImages=true \\                                                                                                                                                         |
|                                                                                                                                                                                           |
|    -dAutoFilterColorImages=false \\                                                                                                                                                       |
|                                                                                                                                                                                           |
|    -dColorImageFilter=/DCTEncode \\                                                                                                                                                       |
|                                                                                                                                                                                           |
|    -c \"\<\</QFactor 0.9 /Quality \$quality \>\> setdistillerparams\" \\                                                                                                                  |
|                                                                                                                                                                                           |
|    -f \"\$1\"                                                                                                                                                                             |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
