echo("\n\n====== HIVE ORGANIZER ======\n\n");

include <game-box/game.scad>

Qprint = Qfinal;  // or Qdraft

// component metrics
Hboard = 9.75;
Rhex = 13.5 / sin(60);
Rhex_single = 12.35 / sin(60);
echo(Rhex=tround(Rhex), across=tround(2*Rhex*sin(60)));
echo(Rhex_single=tround(Rhex_single), across=tround(2*Rhex_single*sin(60)));
Rmagnet = 3;
Hmagnet = 2;
Rbase = 42.5;
Hbase = Hfloor + Hmagnet;
Htier = 2*Hfloor + Hboard;
Hlegs = 2*Htier - 2*Hmagnet;
echo(Hbase=Hbase, Htier=Htier, Hlegs=Hlegs);

Ghive = [[0, 0], [1, 0], [0, 1], [-1, 1], [-1, 0], [0, -1], [1, -1]];

module hive_window(hole=Dthumb) {
    prism(height=Hfloor+2*Dcut, r=Rint/2) hex(Ghive, r=hole/2);
}
module hive_stack(height=2*Htier, r=Rhex, roff=0, color=undef) {
    echo(height=height, r=r);
    colorize(color) prism(height=height, r=Rext/2+roff) hex(Ghive, r=Rhex+roff);
}
module hive_magnets(r) {
    for (j=[-1,+1]) translate([0, (r-Rmagnet-Dwall)*j, -Hmagnet])
        cylinder(h=Hmagnet+Dcut, r=Rmagnet);
}
module hive_base(height=Hbase, r=Rbase, color=undef) {
    colorize(color) {
        cylinder(h=height, r=r);
        hive_stack(height=height, r=Rhex, roff=Rint/2+Dwall);
    }
}
module hive_lid(color=undef) {
    hive_caddy(legs=0, color=color);
}
module hive_caddy(base=Hbase, legs=Hlegs, color=undef) {
    h = base+legs;
    rwell = Rhex - Dwall/2/sin(60);
    colorize(color) difference() {
        union() {
            hive_base(color=color);
            if (legs) prism(height=h, r=Rext) intersection() {
                circle(r=Rbase);
                square([Rhex, 2*Rbase], center=true);
            }
        }
        raise(Hfloor) hive_stack(height=2*Htier+1, roff=Rint/2);
        raise(-Dcut) hive_window();
        raise(h) hive_magnets(r=Rbase);
    }
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

hive_grid($fa=Qprint);
*hive_lid($fa=Qprint);
*hive_caddy($fa=Qprint);
