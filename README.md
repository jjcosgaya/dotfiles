# Dotfiles

Mis configs, gestionadas con [GNU Stow](https://www.gnu.org/software/stow/).

## Estructura

Un paquete por app. La estructura interna se reproduce en `~`:

```
~/.dotfiles/
├── bash/.bashrc
├── defaults/.config/mimeapps.list + environment.d/10-default-apps.conf
├── gnupg/.gnupg/gpg-agent.conf + .local/bin/pinentry-smart
├── pass/.local/bin/pass-fuzzel
├── gtk/.config/gtk-3.0/ + gtk-4.0/ + .gtkrc-2.0
├── niri/.config/niri/ + .local/bin/lock-screen
├── lsd/.config/lsd/
├── mako/.config/mako/
├── wallpapers/Pictures/minimalist_black_landscape.jpg
├── waybar/.config/waybar/
├── xdg-desktop-portal/.config/xdg-desktop-portal/
├── wezterm/.wezterm.lua
├── vimium/vimium-options.json (importación manual; ignorado por Stow)
├── userscripts/youtube-speed-control.user.js (instalación manual; ignorado por Stow)
└── zathura/.config/zathura/zathurarc
```

La exportación de Vimium no se lee desde una ruta del sistema: se restaura desde
la página de opciones de la extensión. Por eso se conserva dentro del paquete
`vimium`, pero `vimium/.stow-local-ignore` evita que `stow */` cree un enlace
inútil en `~`. Para restaurarla, abre **Vimium → Options → Import/Export** y
selecciona `vimium/vimium-options.json`.

El paquete `userscripts` contiene un userscript para YouTube. Añade un control
compacto junto a los controles nativos del reproductor: las flechas cambian la
velocidad en pasos de `0.1×`, la rueda sobre el control también la cambia y el
botón central vuelve a `1×`. `Shift` usa pasos de `0.25×`; además, `[` y `]`
funcionan como atajos de teclado. La última velocidad elegida se conserva para
los vídeos siguientes. Como YouTube no ofrece una ruta de configuración para
este tipo de script, `userscripts/.stow-local-ignore` evita que Stow lo enlace
en `~`.

Para instalarlo, instala [Violentmonkey](https://violentmonkey.github.io/) o
Tampermonkey, crea un script nuevo desde su panel y pega el contenido de
`userscripts/youtube-speed-control.user.js`. Si ya existe la versión anterior,
sustituye su contenido por el archivo actualizado, guarda y recarga YouTube
completamente (no basta con cambiar el archivo del repositorio). Con Wayland,
`wl-copy < userscripts/youtube-speed-control.user.js` permite copiarlo al
portapapeles. Para un único ajuste de la interfaz, un userscript es más
sencillo que crear y mantener una extensión completa.

## Instalar stow

```bash
sudo zypper install stow   # openSUSE
sudo apt install stow      # Debian/Ubuntu
sudo pacman -S stow        # Arch
```

## Uso

Desde `~/.dotfiles`:

```bash
stow */          # enlazar TODO (un paquete por carpeta)
stow niri        # enlazar un paquete concreto
stow -R niri     # re-enlazar tras cambios
stow -D niri     # desenlazar
stow -n -v */    # simular sin hacer nada
```

## Añadir un paquete

```bash
mkdir -p ~/.dotfiles/miapp/.config
mv ~/.config/miapp ~/.dotfiles/miapp/.config/
cd ~/.dotfiles && stow miapp
```

## Notas

- El paquete `defaults` gestiona las aplicaciones predeterminadas: Brave para HTML y enlaces web,
  Neovim para texto/código, Zathura para PDF y Thunar para carpetas. También configura
  `EDITOR`, `VISUAL`, `GIT_EDITOR`, `SUDO_EDITOR`, `BROWSER` y `TERMINAL`. Los cambios en
  `~/.config/mimeapps.list` o `~/.config/environment.d/10-default-apps.conf` requieren reiniciar
  las aplicaciones afectadas; las variables de entorno gráficas suelen requerir cerrar y volver
  a iniciar sesión.
- Los enlaces son simbólicos: editar `~/.config/...` o `~/.dotfiles/...` es lo mismo.
- `Mod+P` abre `pass-fuzzel`: selecciona una entrada de `pass` con fuzzel y copia la contraseña usando `pass -c`.
  `Mod+U` hace lo mismo con `--username`, copiando el último componente de una entrada como `url/username`.
  También puedes ejecutarlo manualmente como `pass-fuzzel --username`.
  Requiere `pass`, `fuzzel` y `wl-clipboard` en Wayland. `pass` limpia la contraseña después de `PASSWORD_STORE_CLIP_TIME` segundos (45 por defecto).
- `Mod+Shift+O` ejecuta `lock-screen`: captura silenciosamente la pantalla enfocada de niri, la oscurece
  y desenfoca con ImageMagick, y la usa como fondo temporal de `swaylock`. La imagen se borra al desbloquear.
  Requiere niri 26.04 o posterior, `swaylock` e ImageMagick.
- `mako` gestiona las notificaciones de Wayland con la paleta Kanagawa Dragon:
  tarjetas oscuras con iconos FairyWren, separación bajo Waybar, acentos por urgencia,
  progreso, historial y acciones con clic. Instala el daemon con `sudo zypper install mako`;
  se inicia junto con niri. Después de enlazarlo con `stow mako`, aplica cambios con
  `makoctl reload`.
- El paquete `gnupg` configura `pinentry-smart`: los comandos de terminal usan `pinentry-curses` y las aplicaciones gráficas usan `pinentry-gnome3`. Instala este último con `sudo zypper in pinentry-gnome3` antes de hacer `stow gnupg`; después recarga con `gpgconf --reload gpg-agent` y abre un terminal nuevo.
- No subir configs que cambien solas (cachés, historiales, sesiones).
- En otra máquina: clonar el repo, `stow */` y listo.
- Los assets de tema/cursor/iconos no están en el repo, pero se distribuyen
  empaquetados en `desktop-assets.tar.gz` (~85 MB; archivo en la raíz del repo,
  ignorado por `stow */`). La forma más fácil de instalarlo todo:

  ```bash
  # desde ~/.dotfiles
  tar -xzf desktop-assets.tar.gz -C /tmp/assets
  mkdir -p ~/.local/share/themes ~/.local/share/icons ~/.icons
  cp -r /tmp/assets/theme/Graphite-Dark ~/.local/share/themes/
  cp -r /tmp/assets/icons/Papirus* ~/.icons/
  cp -r /tmp/assets/cursor/Bibata-Modern-Ice ~/.local/share/icons/
  ln -sfn ~/.local/share/icons/Bibata-Modern-Ice ~/.icons/Bibata-Modern-Ice
  gtk-update-icon-cache ~/.icons/FairyWren
  rm -rf /tmp/assets
  ```

  Cambiar color de carpetas: `ln -sfn <color> ~/.icons/FairyWren/places/colours/default`
  (colores: white, blue, green, red, etc.; ver con `ls ~/.icons/FairyWren/places/colours/`).
  Tras cambiar, `gtk-update-icon-cache ~/.icons/FairyWren` y reiniciar apps.

  El archivo incluye además un `INSTALL.md` y el parche
  `patches/graphite-kanagawa-dragon.patch` para reconstruir el tema desde el
  fuente.

- Instalación manual (alternativa, si prefieres descargar todo a mano):

  **Tema GTK** — [Graphite-gtk-theme](https://github.com/vinceliuice/Graphite-gtk-theme):

  ```bash
  cd Graphite-gtk-theme
  ./install.sh -c dark -l
  ```

  Requiere `sassc` (openSUSE: `sudo zypper install sassc`).
  El fondo oscuro está parcheado a la paleta **Kanagawa dragon** (`#181616`):
  editar `src/sass/_colors.scss`, en `background()` dentro del bloque
  `$color_type == 'default'` (rama no-`darker`):

  ```scss
  @if ($type == 'e') { @return #0d0c0c; } // bg_dim
  @if ($type == 'f') { @return #16161d; } // bg_s
  @if ($type == 'g') { @return #181616; } // bg
  @if ($type == 'h') { @return #1f1d1e; } // bg_p1
  ```

  (O aplicar el parche del tarball: `patch -p1 < /path/patches/graphite-kanagawa-dragon.patch`.)

  Adicionalmente, dos parches para evitar texto negro por defecto sobre el fondo
  oscuro (la herencia de `color` no siempre llega a sidebars / statusbars en
  GTK3, y se queda en el negro por defecto):

  - `src/sass/gtk/_common-3.0.scss` → `placessidebar.sidebar { row { color: $text; ... } }`
  - `src/sass/gtk/apps/_xfce.scss` → al inicio de `.thunar { color: $text; ... }`

  Además, el **keybind de los menús** (el accelerator a la derecha de cada ítem)
  salía negro sobre el fondo oscuro: en los menús clásicos de GTK3 (Thunar/Xfce)
  `:selected` gana el fondo (oscuro `mix($text,$base,10%)` ≈ `#2f2d2d`) sobre
  la "píldora" clara `$primary` del `:hover`, pero el accelerator sólo tenía regla
  `:hover` (negra). En `src/sass/gtk/_common-3.0.scss`, dentro del bloque de
  `menu`, cambiar el `&:hover` del menuitem a superficie oscura + texto claro:

  ```scss
  &:hover {
    background-color: mix($text, $base, 10%);
    color: $text;
    accelerator { color: $text-secondary; }
    &:disabled accelerator { color: $text-secondary-disabled; }
  }
  ```

  **Iconos** — **FairyWren** (carpetas en blanco por defecto; basado en Papirus,
  [gitlab.com/FreshDoctor/FairyWren-Icons](https://gitlab.com/FreshDoctor/FairyWren-Icons)):

  ```bash
  # Tema empaquetado en desktop-assets.tar.gz (ver sección anterior).
  # Desde el repo upstream, el install.sh es interactivo; el tar evita eso.
  ```

  El nombre del tema en `index.theme` es `FairyWren` (sin "Dark") — algunas
  instalaciones de GTK conservan un caché persistente que rechaza ciertos
  nombres; este funciona de forma fiable. Para cambiar el color de las carpetas:

  ```bash
  ln -sfn white ~/.icons/FairyWren/places/colours/default
  gtk-update-icon-cache ~/.icons/FairyWren
  ```

  Alternativa anterior: **Papirus** (instalado con
  `wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.icons" sh`;
  color de carpetas con `papirus-folders -C <color> -t Papirus-Dark -u`).

- El tema de cursores (**Bibata Modern Ice**) tampoco está en el repo: descomprimir el
  `.tar.xz` en `~/.local/share/icons/` **y** enlazarlo en `~/.icons/`:

  ```bash
  mkdir -p ~/.local/share/icons ~/.icons
  tar -xf ~/Downloads/Bibata-Modern-Ice.tar.xz -C ~/.local/share/icons
  ln -sfn ~/.local/share/icons/Bibata-Modern-Ice ~/.icons/Bibata-Modern-Ice
  ```

  > El enlace en `~/.icons` es obligatorio: niri (crate `xcursor` 0.3.10) no busca
  > `$XDG_DATA_HOME/icons` cuando `XDG_DATA_HOME` está definido, pero `~/.icons`
  > siempre está en su ruta de búsqueda.

  La config de niri (`cursor {}`) ya apunta a `Bibata-Modern-Ice` y exporta
  `XCURSOR_THEME`/`XCURSOR_SIZE` para los clientes. Tras instalar, recargar con
  `Mod+Shift+F5` (si el bloque `cursor {}` no cambió, niri no recarga el tema:
  tocar `xcursor-size` y volver, o reiniciar la sesión).
