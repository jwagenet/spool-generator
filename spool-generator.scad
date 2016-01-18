/*  Spool Generator: Generate custom size spools and reels for wire, filament, string, etc.
    By Jonathan Wagenet 2016-01-17
   
*/   

spool_diameter          = 20;
barrel_diameter         = 27;
barrel_width            = 10;
flange_diameter         = 80;
flange_width            = 1.5;

thread_length           = 6;
thread_pitch            = 2;
thread_outer_diameter   = 24;
thread_inner_diameter   = 25;


//spool_cap(spool_diameter,barrel_diameter,barrel_width,flange_diameter,flange_width,thread_length,thread_pitch,thread_outer_diameter,thread_outer_diameter);
spool_body(spool_diameter,barrel_diameter,barrel_width,flange_diameter,flange_width,thread_length,thread_pitch,thread_outer_diameter,thread_inner_diameter);



module spool_cap(sd,bd,bw,fd,fw,tl,tp,tg,tid){
    difference(){
        union(){
            flange(fd,fw);

            translate([0,0,fw])screw_thread(tid,tp,45,tl,1,-2);
        }
        translate([0,0,-.1])cylinder(fw+tl*tp+.2,d=20,$fn=100);
    }
}

module spool_body(sd,bd,bw,fd,fw,tl,tp,tg,tod){
    difference(){
        union(){
            flange(fd,fw);
            translate([0,0,fw])cylinder(bw,d=bd,$fn=100);
        }
        
        translate([0,0,-.1])cylinder(fw+tl*tp+.2,d=20,$fn=100);
        translate([0,0,fw+bw-tl-1])screw_thread(tod,tp,45,tl+1,1,1);
        
        countersink_end(tp/2,tod,45,1,tl+1,bw,fw);
    }
}

module flange(fd,fw){
    cylinder(fw,d=fd,$fn=100);
}
module barrel(tl){}

module countersink_end(chg,cod,clf,crs,hg,bw,fw){
    translate([0,0,bw+fw-chg+0.1])
    cylinder(h=chg+0.01, 
             r1=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             r2=cod/2, 
             $fn=floor(cod*PI/crs), center=false);
}

/* Library included below to allow customizer functionality    
 *
 *    polyScrewThread_r1.scad    by aubenc @ Thingiverse
 *
 *Truncated to provide required support. Above module countersink_end is lifted and edited from hex_countersink_ends
 *
 * This script contains the library modules that can be used to generate
 * threaded rods, screws and nuts.
 *
 * http://www.thingiverse.com/thing:8796
 *
 * CC Public Domain
 */

module screw_thread(od,st,lf0,lt,rs,cs)
{
    or=od/2;
    ir=or-st/2*cos(lf0)/sin(lf0);
    pf=2*PI*or;
    sn=floor(pf/rs);
    lfxy=360/sn;
    ttn=round(lt/st+1);
    zt=st/sn;

    intersection()
    {
        if (cs >= -1)
        {
           thread_shape(cs,lt,or,ir,sn,st);
        }

        full_thread(ttn,st,sn,zt,lfxy,or,ir);
    }
}



module thread_shape(cs,lt,or,ir,sn,st)
{
    if ( cs == 0 )
    {
        cylinder(h=lt, r=or, $fn=sn, center=false);
    }
    else
    {
        union()
        {
            translate([0,0,st/2])
              cylinder(h=lt-st+0.005, r=or, $fn=sn, center=false);

            if ( cs == -1 || cs == 2 )
            {
                cylinder(h=st/2, r1=ir, r2=or, $fn=sn, center=false);
            }
            else
            {
                cylinder(h=st/2, r=or, $fn=sn, center=false);
            }

            translate([0,0,lt-st/2])
            if ( cs == 1 || cs == 2 )
            {
                  cylinder(h=st/2, r1=or, r2=ir, $fn=sn, center=false);
            }
            else
            {
                cylinder(h=st/2, r=or, $fn=sn, center=false);
            }
        }
    }
}

module full_thread(ttn,st,sn,zt,lfxy,or,ir)
{
  if(ir >= 0.2)
  {
    for(i=[0:ttn-1])
    {
        for(j=[0:sn-1])
			assign( pt = [	[0,                  0,                  i*st-st            ],
                        [ir*cos(j*lfxy),     ir*sin(j*lfxy),     i*st+j*zt-st       ],
                        [ir*cos((j+1)*lfxy), ir*sin((j+1)*lfxy), i*st+(j+1)*zt-st   ],
								[0,0,i*st],
                        [or*cos(j*lfxy),     or*sin(j*lfxy),     i*st+j*zt-st/2     ],
                        [or*cos((j+1)*lfxy), or*sin((j+1)*lfxy), i*st+(j+1)*zt-st/2 ],
                        [ir*cos(j*lfxy),     ir*sin(j*lfxy),     i*st+j*zt          ],
                        [ir*cos((j+1)*lfxy), ir*sin((j+1)*lfxy), i*st+(j+1)*zt      ],
                        [0,                  0,                  i*st+st            ]	])
        {
            polyhedron(points=pt,
              		  triangles=[	[1,0,3],[1,3,6],[6,3,8],[1,6,4],
											[0,1,2],[1,4,2],[2,4,5],[5,4,6],[5,6,7],[7,6,8],
											[7,8,3],[0,2,3],[3,2,7],[7,2,5]	]);
        }
    }
  }
  else
  {
    echo("Step Degrees too agresive, the thread will not be made!!");
    echo("Try to increase de value for the degrees and/or...");
    echo(" decrease the pitch value and/or...");
    echo(" increase the outer diameter value.");
  }
}

module hex_countersink_ends(chg,cod,clf,crs,hg)
{
    /*translate([0,0,-0.1])
    cylinder(h=chg+0.01, 
             r1=cod/2, 
             r2=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             $fn=floor(cod*PI/crs), center=false);*/

    translate([0,0,hg-chg+0.1])
    cylinder(h=chg+0.01, 
             r1=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             r2=cod/2, 
             $fn=floor(cod*PI/crs), center=false);
}