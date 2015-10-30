# Troya - sistema host para la instalación de un sistema LFS/UPM

El objetivo de este proyecto es lograr un sistema booteable Archlinux 
con las siguientes funcionalidades:

- Cuentas de usuario <tt>root</tt> y <tt>lfs</tt> listas para comenzar a
trabajar.
- Un sistema gráfico muy simple para trabajar cómodamente (Weston).
- Toda la documentación de LFS y BLFS disponible en <tt>/doc</tt>.
- El código fuente de todos los paquetes esenciales para LFS en 
<tt>/sources</tt>, incluyendo los paquetes <tt>upm</tt> y 
<tt>filesystem</tt>.
- Un repositorio de <tt>upmdb</tt> compatible con las fuentes provistas, 
comprimido también en <tt>/sources</tt>.
- Un servidor <tt>ssh</tt> para acceder al sistema remotamente mediante el
nombre de host <tt>troya</tt>.

EL directorio <tt>archiso-troya</tt> es un proyecto de <tt>archiso</tt>.
Si ejecutamos el script <tt>build.sh</tt> ubicado en dicho directorio, se 
generará el archivo <tt>.iso</tt> booteable con estas características.

Para esto es necesario tener instalado el paquete <tt>archiso</tt>, 
disponible en el repositorio <tt>extra</tt> de Archlinux.