echo("\n\n====== HIVE ORGANIZER ======\n\n");

include <game-box/game.scad>

Qprint = Qfinal;  // or Qdraft

// organizer metrics
Rint = 0.5;
Rext = 1.5;

// component metrics
Hboard = 9.75;
Rhex = 16;
Rhex_single = 14.25;

Ghive = [[0, 0], [1, 0], [0, 1], [-1, 1], [-1, 0], [0, -1], [1, -1]];

module hive_grid(color=undef) {
    colorize(color) difference() {
        prism(height=2*Hfloor, r=Rext) hex(Ghive);
        raise(Hfloor) prism(height=Hfloor+Dcut, r=Rint)
            offset(delta=Rint) hex(Ghive, r=Rhex_single);
        raise(-Dcut) prism(height=Hfloor+2*Dcut, r=Rint) hex(Ghive, Dthumb/2);
    }
}

hive_grid($fa=Qprint);
