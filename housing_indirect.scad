smoothness = 100;
h = 40;
r = 70;
outer_wall = 5;

inner_h = h - 2*outer_wall;

sensor_r = 8;
sensor_w = 3;
sensor_h = 30;
ceiling_h = 50;
sensor_dist = 20;
sensor_back = 2;
sensor_ramp_len = 20;
sensor_dist_to_edge = 15;
sensor_cable_hole_r = 4;
mount_fix_r = 20;
mount_fix_wall = 3;

a = atan(ceiling_h / (2*r - 2*sensor_dist_to_edge - sensor_h) *2);
alpha = a;
echo (alpha);
module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
       }
 

module sensor () {
    union() {        
        translate([-sensor_dist_to_edge,0, h + sensor_w + 5 ])
        rotate([0,90 + alpha ,0])
            //hole for sensor
            difference(){
                    //base fixture with cylinder on top
                    union() {
                        cylinder(h = sensor_h, r1 = sensor_r + sensor_w, r2 = sensor_r + sensor_w,center = false, $fn = smoothness);
                        
                    }
            cylinder(h = sensor_h-sensor_back, r1 = sensor_r, r2 = sensor_r,center = false, $fn = smoothness);
        }
    }
}


//fixture for mounting-plate
union() {
    
    //ceiling
    tmp = sqrt(2) * 0.5 * (r - outer_wall);
    translate([tmp,tmp, h])
    cylinder(h =  ceiling_h, r1 = 3, r2 = 3,center = false, $fn = smoothness);
    translate([tmp,-tmp, h ])
    cylinder(h =  ceiling_h, r1 = 3, r2 = 3,center = false, $fn = smoothness);
    translate([-tmp,tmp, h ])
    cylinder(h =  ceiling_h, r1 = 3, r2 = 3,center = false, $fn = smoothness);
    translate([-tmp,-tmp, h ])
    cylinder(h =  ceiling_h, r1 = 3, r2 = 3,center = false, $fn = smoothness);
    translate([0,0, h + ceiling_h ])
    cylinder(h = 3, r1 = r, r2 = r,center = false, $fn = smoothness);
    
    
    //area for circuits
    difference() {
        // ensures round outer shape (removes any edges outside of cylinder) and adds center hole
        difference(){
            //cable holes
            difference() {
                difference() {
                    difference() {
                        difference() {
                            //cylinder with sensor mounts
                            union() {
                                cylinder(h = h, r1 = r, r2 = r,center = false, $fn = smoothness);
                                //sensormounts
                                translate([r -sensor_dist_to_edge/2, 0, 0])
                                sensor(); 
                                translate([-r +sensor_dist_to_edge/2 , 0, 0])
                                rotate([0,0,180])
                                sensor(); 
                                rotate([0,0,90])
                                translate([r -sensor_dist_to_edge/2, 0, 0])
                                sensor(); 
                                rotate([0,0,90])
                                translate([-r +sensor_dist_to_edge/2, 0, 0])
                                rotate([0,0,180])
                                sensor(); 
                            }
                            
                                translate([r ,0,0])
                                translate([-sensor_dist_to_edge,0, inner_h])
                                cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
                            }
                                translate([-r, 0, 0])
                                rotate([0,0,180])
                                translate([-sensor_dist_to_edge,0, inner_h])
                                cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
                        }
                        rotate([00,00,90])
                        translate([r, 0, 0])
                        translate([-sensor_dist_to_edge,0, inner_h])
                        cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
                    }
                rotate([0,00,90])
                translate([-r, 0, 0])
                rotate([0,0,180])
                translate([-sensor_dist_to_edge,0, inner_h])
                cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
            }
            difference() {
             cylinder(h = 1000, r1 = 1000, r2 = 1000,center = false, $fn = smoothness);
             cylinder(h = 1000, r1 = r, r2 = r,center = false, $fn = smoothness);     
         }
         translate([0,0, inner_h])
        cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
            
        }
        cylinder(h = inner_h, r1 = r - outer_wall, r2 = r - outer_wall,center = false, $fn = smoothness);
    }
    union() {
        difference() {
            
            cylinder(h = inner_h, r1 = mount_fix_r + mount_fix_wall, r2 = mount_fix_r + mount_fix_wall,center = false, $fn = smoothness);
            cylinder(h = inner_h, r1 = mount_fix_r, r2 = mount_fix_r,center = false, $fn = smoothness);
        }
        translate([0,mount_fix_r - mount_fix_wall , inner_h/2])
        cube([2*mount_fix_wall,2*mount_fix_wall,inner_h] ,center = true);
    }
}