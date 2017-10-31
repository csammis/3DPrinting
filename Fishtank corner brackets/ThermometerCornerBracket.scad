//
// 29g tank rim bracket for holding a Neptune Apex temperature probe
// Design by Chris Sammis, 2017
//

/****** Constants ********************/
RIM_HEIGHT  = 7.5;      // These work well for a 29g from Petco
RIM_WIDTH   = 11.85;
CUTOUT_LENGTH = 100;

/****** Bracket dimensions ***********/
bracket_length  = 70;
bracket_width   = 20;
edge_width      = 2;

/****** Probe cord dimensions ********/
cord_diameter       = 5;
cord_wall_width     = 2;
cord_ring_height    = 5;

/****** Probe dimensions *************/
probe_outer_diameter    = 14;
probe_ring_height       = RIM_HEIGHT;

// Generic ring for holding a cylindrical object (probe, cord, airline, etc.)
module holder_ring(inner_diameter, wall_width, height)
{
    ring_resolution = 30;

    difference()
    {
        cylinder(r=(inner_diameter / 2) + wall_width, h=height, $fn=ring_resolution);
        translate([0, 0, -0.01])
            cylinder(r=inner_diameter / 2, h=height + 0.02, $fn=ring_resolution);

        // Open up 4/5s of the inner diameter to put the object through
        translate([inner_diameter / 2, 0, height / 2])
            cube([inner_diameter, (inner_diameter * 4) / 5, height * 2], center=true);
    }
}

module probe()
{
    translate([bracket_length - probe_outer_diameter / 2, -5, RIM_HEIGHT + edge_width - cord_ring_height])
        rotate([0, 0, -90])
            holder_ring(cord_diameter, cord_wall_width, cord_ring_height);

    translate([bracket_length - probe_outer_diameter / 2, bracket_width * 1.25, RIM_HEIGHT + edge_width - probe_ring_height])
        rotate([0, 0, 90])
            holder_ring(probe_outer_diameter, 2, probe_ring_height);
}

union()
{
    difference()
    {
        translate([edge_width * -1, edge_width * -1, 0.01])
        {
            cube([bracket_length, bracket_width, RIM_HEIGHT + edge_width]);
        }
        
        union()
        {
            cube([CUTOUT_LENGTH, RIM_WIDTH, RIM_HEIGHT]);
            translate([RIM_WIDTH, 0, 0])
                rotate([0, 0, 90])
                    cube([CUTOUT_LENGTH, RIM_WIDTH, RIM_HEIGHT]);
        }
    }
    
    probe();
}