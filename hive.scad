echo("\n\n====== HIVE ORGANIZER ======\n\n");

include <game-box/game.scad>

Qprint = Qfinal;  // or Qdraft

// component metrics
Hboard = 9.75;
Rhex = 13.5 / sin(60);
Rhex_single = 12.35 / sin(60);
Hstack = 4 * (2*Hfloor + Hboard);
echo(Rhex=tround(Rhex), across=tround(2*Rhex*sin(60)));
echo(Rhex_single=tround(Rhex_single), across=tround(2*Rhex_single*sin(60)));
Rmagnet = 3;
Hmagnet = 2;
Rbase = 42.5;
Hbase = 2 * (Hfloor + Hmagnet);
Hshell = 2*Hfloor + Hstack + 1;

Ghive = [[0, 0], [1, 0], [0, 1], [-1, 1], [-1, 0], [0, -1], [1, -1]];

module hive_window(hole=Dthumb) {
    prism(height=Hfloor+2*Dcut, r=Rint/2) hex(Ghive, r=hole/2);
}
module hive_stack(height=Hstack, r=Rhex, roff=0, color=undef) {
    echo(height=height, r=r);
    colorize(color) prism(height=height, r=Rext/2+roff) hex(Ghive, r=Rhex+roff);
}
module hive_magnets(r) {
    for (j=[-1,+1]) translate([0, (r-Rmagnet-Dwall)*j, -Hmagnet])
        cylinder(h=Hmagnet+Dcut, r=Rmagnet);
}
module hive_base(height=Hbase, r=Rbase, color=undef) {
    colorize(color) hull() {
        cylinder(h=height, r=r);
        cylinder(h=height+r/2, r=r/2);
    }
}
module hive_shell(color=undef) {
    colorize(color) difference() {
        union() {
            hive_base(height=Hbase, r=Rbase, color=color);
            hive_stack(height=Hshell, r=Rhex, roff=Rint/2+Dwall);
            raise(Hshell) scale([1, 1, -1])
                hive_base(height=Hbase, r=Rbase, color=color);
        }
        raise(Hfloor) hive_stack(height=Hstack+1, roff=Rint/2);
        raise(-Dcut) hive_window();
        raise(Hshell+Dcut) scale([1, 1, -1]) hive_window();
    }
    %raise() hive_stack();
}
module hive_cut(height, color=undef) {
    colorize(color) difference() {
        intersection() {
            cylinder(h=height, r=2*Rbase);
            hive_shell(color=color);
        }
        raise(height) hive_magnets(r=Rbase);
    }
}
module hive_lid(color=undef) {
    colorize(color) hive_cut(Hfloor+Hmagnet);
}
module hive_jar(color=undef) {
    colorize(color) hive_cut(Hshell-Hfloor-Hmagnet);
}
module hive_grid(r=Rhex, hole=Dthumb, color=undef) {
    rwell = r - Dwall/2/sin(60);
    rhole = hole/2;
    colorize(color) difference() {
        prism(height=2*Hfloor, r=Rext/2) hex(Ghive);
        raise(Hfloor) prism(height=Hfloor+Dcut, r=Rint/2) hex(Ghive, r=rwell);
        raise(-Dcut) hive_window();
    }
}

*hive_grid($fa=Qprint);
*hive_lid($fa=Qprint);
hive_jar($fa=Qprint);
