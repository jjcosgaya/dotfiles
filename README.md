# Dotfiles

Configuración personal de openSUSE/Wayland, gestionada con
[GNU Stow](https://www.gnu.org/software/stow/). Cada carpeta es un paquete y
su estructura interna se reproduce en `~`.

## Paquetes

| Paquete | Contenido |
| --- | --- |
| `bash`, `tmux`, `wezterm` | Shell, multiplexor y terminal |
| `defaults` | Aplicaciones y variables de entorno predeterminadas |
| `fuzzel`, `lsd`, `mako`, `waybar` | Escritorio y utilidades Wayland |
| `gtk`, `niri`, `xdg-desktop-portal` | Tema y sesión gráfica |
| `nvim`, `zathura` | Editor y lector PDF |
| `gnupg`, `pass` | GPG, `pinentry-smart` y accesos rápidos para `pass` |
| `pi` | Skills locales de Pi |
| `wallpapers` | Fondo de pantalla |
| `vimium`, `userscripts` | Configuración y scripts de navegador (instalación manual) |

## Instalación

```bash
sudo zypper install stow

git clone --branch opensuse-laptop \
  https://github.com/jjcosgaya/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow */
```

`stow */` enlaza todos los paquetes. Para probar sin modificar nada:

```bash
stow -n -v */
```

Operaciones habituales:

```bash
stow niri        # enlazar un paquete
stow -R niri     # volver a enlazarlo
stow -D niri     # desenlazarlo
```

Los enlaces son simbólicos: editar `~/.config/...` o el archivo correspondiente
en `~/.dotfiles` tiene el mismo efecto.

## Notas de paquetes

- `defaults` configura Brave para HTML y enlaces web, Neovim para texto/código,
  Zathura para PDF y Thunar para carpetas. También define `EDITOR`, `VISUAL`,
  `GIT_EDITOR`, `SUDO_EDITOR`, `BROWSER` y `TERMINAL`. Reinicia las aplicaciones
  afectadas después de cambiar estas opciones; las variables gráficas suelen
  requerir cerrar y volver a iniciar sesión.
- `pass-fuzzel` se abre con `Mod+P` y copia contraseñas con `pass -c`. `Mod+U`
  copia el usuario. Requiere `pass`, `fuzzel` y `wl-clipboard`.
- `lock-screen` se abre con `Mod+Shift+O`, captura la pantalla enfocada de niri
  y la usa temporalmente con `swaylock`. Requiere niri 26.04+, `swaylock` e
  ImageMagick.
- `mako` gestiona las notificaciones. Instálalo con `sudo zypper install mako`
  y aplica cambios con `makoctl reload`.
- `gnupg` usa `pinentry-curses` en terminal y `pinentry-gnome3` en aplicaciones
  gráficas. En openSUSE: `sudo zypper install pinentry-gnome3`; después ejecuta
  `gpgconf --reload gpg-agent` y abre un terminal nuevo.
- No guardes aquí cachés, historiales, sesiones ni otras configuraciones que
  cambien automáticamente.

## Vimium y userscript de YouTube

Estos paquetes incluyen archivos que no deben enlazarse con Stow; sus archivos
`.stow-local-ignore` se encargan de ello.

- **Vimium:** abre **Vimium → Options → Import/Export** y selecciona
  `vimium/vimium-options.json`.
- **YouTube:** instala [Violentmonkey](https://violentmonkey.github.io/) o
  Tampermonkey y pega `userscripts/youtube-speed-control.user.js` en un script
  nuevo. Las flechas y la rueda cambian la velocidad en pasos de `0.1×`, el
  botón central vuelve a `1×`, `Shift` usa pasos de `0.25×` y `[`/`]` también
  funcionan como atajos. La velocidad se conserva entre vídeos.

Después de actualizar el script, guárdalo y recarga YouTube completamente. En
Wayland se puede copiar con:

```bash
wl-copy < userscripts/youtube-speed-control.user.js
```

## Tema, iconos y cursores

`desktop-assets.tar.gz` contiene el tema **Graphite-Dark** (paleta Kanagawa),
los iconos **FairyWren**, los cursores **Bibata Modern Ice**, un `INSTALL.md` y
el parche para reconstruir el tema desde su fuente.

Para instalar los assets empaquetados:

```bash
mkdir -p /tmp/assets ~/.local/share/themes ~/.local/share/icons ~/.icons
tar -xzf desktop-assets.tar.gz -C /tmp/assets

cp -r /tmp/assets/theme/Graphite-Dark ~/.local/share/themes/
cp -r /tmp/assets/icons/FairyWren ~/.icons/
cp -r /tmp/assets/cursor/Bibata-Modern-Ice ~/.local/share/icons/
ln -sfn ~/.local/share/icons/Bibata-Modern-Ice ~/.icons/Bibata-Modern-Ice
gtk-update-icon-cache ~/.icons/FairyWren
rm -rf /tmp/assets
```

El enlace del cursor en `~/.icons` es necesario para que niri lo encuentre.
Para cambiar el color de las carpetas:

```bash
ln -sfn <color> ~/.icons/FairyWren/places/colours/default
gtk-update-icon-cache ~/.icons/FairyWren
```

Los colores disponibles se pueden consultar con:

```bash
ls ~/.icons/FairyWren/places/colours/
```

Para reconstruir el tema GTK desde el fuente, consulta el `INSTALL.md` del
archivo; requiere `sassc`. El parche incluido conserva el fondo oscuro
**Kanagawa dragon** y corrige el texto de sidebars, Thunar y aceleradores de
menús GTK3.

## Añadir un paquete

```bash
mkdir -p ~/.dotfiles/miapp/.config
mv ~/.config/miapp ~/.dotfiles/miapp/.config/
cd ~/.dotfiles && stow miapp
```
