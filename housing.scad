smoothness = 100;
h = 60;
r = 140;
inner_h = 50;
inner_r = 135;

sensor_r = 8;
sensor_w = 3;
sensor_h = 12;
sensor_dist = 20;
sensor_back = 2;
sensor_ramp_len = 20;
sensor_dist_to_edge = 15;
sensor_cable_hole_r = 4;
mount_fix_r = 20;
mount_fix_wall = 3;
module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
       }
   

module sensor () {
    translate([-sensor_dist_to_edge,0, h + sensor_dist+ sensor_r * 2 + sensor_w * 2])
    rotate([0,90,0])
    // hole for cables
    difference() {
        //hole for sensor
        difference(){
                //base fixture with cylinder on top
                union() {
                    cylinder(h = sensor_h, r1 = sensor_r + sensor_w, r2 = sensor_r + sensor_w,center = false, $fn = smoothness);
                    translate([0,-sensor_r - sensor_w, ])
                    cube([sensor_h + sensor_r + sensor_w + sensor_dist, 2*(sensor_r + sensor_w),sensor_h]); 
                    rotate([0,180,-90])
                    translate([-(sensor_r + sensor_w), sensor_r, 0])
                    prism(2*(sensor_r + sensor_w), sensor_h + sensor_w + sensor_dist,sensor_ramp_len );
                }
                rotate([0,90,0])
                translate([-sensor_h/2, 0, 0])
            cylinder(h =sensor_h + sensor_w + sensor_dist + sensor_dist, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
        }
        cylinder(h = sensor_h-sensor_back, r1 = sensor_r, r2 = sensor_r,center = false, $fn = smoothness);
    }
}


//fixture for mounting-plate
union() {
    //area for circuits
    difference() {
        // ensures round outer shape (removes any edges outside of cylinder) and adds center hole
        difference(){
            //cylinder with sensor mounts
            union() {
                //cable holes
                difference() {
                    difference() {
                        difference() {
                            difference() {
                                cylinder(h = h, r1 = r, r2 = r,center = false, $fn = smoothness);
                                    translate([r - sensor_h,0,0])
                                    translate([sensor_h/2 -sensor_dist_to_edge,0, inner_h])
                                    cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
                                }
                                    translate([-r + sensor_h , 0, 0])
                                    rotate([0,0,180])
                                    translate([sensor_h/2 -sensor_dist_to_edge,0, inner_h])
                                    cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
                            }
                            rotate([00,00,90])
                            translate([r - sensor_h, 0, 0])
                            translate([sensor_h/2 -sensor_dist_to_edge,0, inner_h])
                            cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
                        }
                    rotate([0,00,90])
                    translate([-r + sensor_h, 0, 0])
                    rotate([0,0,180])
                    translate([sensor_h/2 -sensor_dist_to_edge,0, inner_h])
                    cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
                }
                     
                //sensormounts
                translate([r - sensor_h, 0, 0])
                sensor(); 
                translate([-r + sensor_h , 0, 0])
                rotate([0,0,180])
                sensor(); 
                rotate([0,0,90])
                translate([r - sensor_h, 0, 0])
                sensor(); 
                rotate([0,0,90])
                translate([-r + sensor_h, 0, 0])
                rotate([0,0,180])
                sensor(); 
            }
            difference() {
             cylinder(h = 1000, r1 = 1000, r2 = 1000,center = false, $fn = smoothness);
             cylinder(h = 1000, r1 = r, r2 = r,center = false, $fn = smoothness);     
         }
         translate([0,0, inner_h])
        cylinder(h =h - inner_h, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
            
        }
        cylinder(h = inner_h, r1 = inner_r, r2 = inner_r,center = false, $fn = smoothness);
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