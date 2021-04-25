__m_dir_color="1;4;38;2;105;172;197"
__m_link_color="1;3;38;2;221;4;138"
__m_multihardlink_color="00"
__m_pipe_color="1;38;2;196;36;132;48;2;170;170;170"
__m_sock_color="1;38;2;2;66;92;48;2;170;170;170"
__m_door_color="1;38;2;2;66;92;48;2;170;170;170"
__m_blk_color="1;38;2;5;138;190"
__m_chr_color="1;3;38;2;5;138;190"
__m_orphan_color="1;38;2;244;127;0"
__m_missing_color="1;38;2;206;109;5"
__m_setuid_color="1;38;2;184;239;63;48;2;85;85;85"
__m_setgid_color="1;38;2;170;170;170;48;2;70;95;2"
__m_capability_color="1;38;2;124;21;83;48;2;170;170;170"
__m_sticky_other_writable_color="1;4;38;2;170;170;170;48;2;5;112;153"
__m_other_writable_color="1;4;38;2;70;95;2;48;2;170;170;170"
__m_sticky_color="1;4;38;2;5;112;153;48;2;170;170;170"
__m_exec_color="1;38;2;157;228;0"

LS_COLORS="rs=0:di=$__m_dir_color:ln=$__m_link_color:mh=$__m_multihardlink_color:pi=$__m_pipe_color:so=$__m_sock_color"
LS_COLORS="$LS_COLORS:do=$__m_door_color:bd=$__m_blk_color:cd=$__m_chr_color:or=$__m_orphan_color:mi=$__m_missing_color"
LS_COLORS="$LS_COLORS:su=$__m_setuid_color:sg=$__m_setgid_color:ca=$__m_capability_color:tw=$__m_sticky_other_writable_color"
LS_COLORS="$LS_COLORS:ow=$__m_other_writable_color:st=$__m_sticky_color:ex=$__m_exec_color"

__m_archive_color="38;2;221;4;138"
__m_archive_extensions=".7z .ace .alz .arc .arj .bz .bz2 .cab .cpio .deb .dwm .dz .ear .esd .gz .jar .lha .lrz .lz .lz4 \
.lzh .lzma .lzo .rar .rpm .rz .sar .swm .t7z .tar .taz .tbz .tbz2 .tgz .tlz .txz .tz .tzo .tzst .war .wim .xz .z .Z .zip \
.zoo .zst"
for archive_extension in $__m_archive_extensions; do
  LS_COLORS="$LS_COLORS:*$archive_extension=$__m_archive_color"
done

__m_image_color="38;2;105;172;197"
__m_image_extensions=".bmp .cgm .emf .gif .jpeg .jpg .mjpeg .mjpg .mng .pbm .pcx .pgm .png .ppm .svg .svgz .tga .tif \
.tiff .xbm .xcf .xpm .xwd"
for image_extension in $__m_image_extensions; do
  LS_COLORS="$LS_COLORS:*$image_extension=$__m_image_color"
done

__m_video_color="38;2;157;228;0"
__m_video_extensions=".asf .avi .flc .fli .flv .gl .m2t .m2ts .m2v .m4p .m4v .mkv .mov .mp2 .mp4 .mp4v .mpe .mpeg .mpg \
.mpv .mts .nuv .ogg .ogm .ogv .qt .rm .rmvb .swf .vob .webm .webm .wmv .yuv"
for video_extension in $__m_video_extensions; do
  LS_COLORS="$LS_COLORS:*$video_extension=$__m_video_color"
done


__m_audio_color="38;2;184;239;63"
__m_audio_extensions=".aac .au .flac .m4a .mid .midi .mka .mp3 .mpc .ra .wav .oga .opus .spx .ogx"
for audio_extension in $__m_audio_extensions; do
  LS_COLORS="$LS_COLORS:*$audio_extension=$__m_audio_color"
done

__m_misc_media_color="38;2;128;185;2"
__m_misc_media_extensions=".xspf"
for misc_media_extension in $__m_misc_media_extensions; do
  LS_COLORS="$LS_COLORS:*$misc_media_extension=$__m_misc_media_color"
done

export LS_COLORS
