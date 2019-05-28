module geometry_lib
contains                                          
!----------------Node to freedom number conversion ---------------------------- 
 subroutine num_to_g(num,nf,g)
 !finds the g vector from num and nf
 implicit none
 integer,intent(in)::num(:),nf(:,:)  ; integer,intent(out):: g(:)
 integer::i,k,nod,nodof ; nod=ubound(num,1) ; nodof=ubound(nf,1)
  do i = 1 , nod
      k = i*nodof  ; g(k-nodof+1:k) = nf( : , num(i) )
  end do
 return
 end subroutine num_to_g   
!-------------------------------- Lines  --------------------------------------
subroutine geometry_2l(iel,ell,coord,num)
! node numbers, nodal coordinates and steering vectors for
! a line of (nonuniform) beam elements
 implicit none
  integer,intent(in)::iel; integer,intent(out)::num(:)
  real,intent(in)::ell; real,intent(out)::coord(:,:)
  num=(/iel,iel+1/)
  if(iel==1)then;coord(1,1)=.0; coord(2,1)=ell; else
    coord(1,1)=coord(2,1); coord(2,1)=coord(2,1)+ell; end if
 end subroutine geometry_2l 
!----------------------------- Triangles --------------------------------------
subroutine geometry_3tx(iel,nxe,aa,bb,coord,num)
!      this subroutine forms the coordinates and node vector
!      for a rectangular mesh of uniform 3-node triangles
!      counting in the x-direction    ; local numbering clockwise
  implicit none
  real,intent(in):: aa,bb; integer,intent(in):: iel,nxe
  real,intent(out) :: coord(:,:); integer,intent(out):: num(:)
  integer::ip,iq,jel
      jel= (2*nxe+iel-1)/(2*nxe)
      if(iel/2*2==iel)then; iq=2*jel; else; iq=2*jel-1; end if
      ip= (iel-2*nxe*(jel-1)+1)/2
      if(mod(iq,2)/=0) then
       num(1)=(nxe+1)*(iq-1)/2+ip  ;   num(3)=(nxe+1)*(iq+1)/2+ip
       num(2)=num(1)+1              ;   coord(1,1)=(ip-1)*aa
       coord(1,2)=-(iq-1)/2*bb      ;   coord(3,1)=(ip-1)*aa
       coord(2,2)=coord(1,2)        ;   coord(2,1)=ip*aa
       coord(3,2)=-(iq+1)/2*bb
      else
       num(1)=(nxe+1)*iq/2+ip+1     ;   num(3)=(nxe+1)*(iq-2)/2+ip+1
       num(2)=num(1)-1               ;   coord(1,1)=ip*aa
       coord(1,2)=-iq/2*bb           ;   coord(3,1)=ip*aa
       coord(3,2)=-(iq-2)/2*bb       ;   coord(2,1)=(ip-1)*aa
       coord(2,2)=coord(1,2)
      end if
     return
   end subroutine geometry_3tx
subroutine geometry_6tx(iel,nxe,aa,bb,coord,num)
!      this subroutine forms the coordinates and nodal vector
!      for a rectangular mesh of uniform 6-node triangles
!      counting in the x-direction ; local numbering clockwise
  implicit none
  real ,intent(in):: aa,bb; integer,intent(in):: iel,nxe
  real,intent(out) :: coord(:,:); integer,intent(out)::  num(:)
  integer::ip,iq,jel,i   
      jel= (2*nxe+iel-1)/(2*nxe)
      if(iel/2*2==iel)then; iq=2*jel; else; iq=2*jel-1; end if
      ip= (iel-2*nxe*(jel-1)+1)/2
      if(mod(iq,2)/=0) then
       num(1)=(iq-1)*(2*nxe+1)+2*ip-1     ;   num(2)=num(1)+1
       num(3)=num(1)+2                    ;   num(4)=num(2)+1 
       num(6)=(iq-1)*(2*nxe+1)+2*nxe+2*ip ;   num(5)=(iq+1)*(2*nxe+1)+2*ip-1
       coord(1,1)=(ip-1)*aa               ;   coord(1,2)=-(iq-1)/2*bb
       coord(5,1)=(ip-1)*aa               ;   coord(5,2)=-(iq+1)/2*bb
       coord(3,1)=ip*aa                   ;   coord(3,2)=coord(1,2)
      else
       num(1)=iq*(2*nxe+1)+2*ip+1       ; num(6)=(iq-2)*(2*nxe+1)+2*nxe+2*ip+2
       num(5)=(iq-2)*(2*nxe+1)+2*ip+1    ; num(4)=num(2)-1
       num(3)=num(1)-2                   ; num(2)=num(1)-1
       coord(1,1)=ip*aa                  ; coord(1,2)=-iq/2*bb
       coord(5,1)=ip*aa                  ; coord(5,2)=-(iq-2)/2*bb
       coord(3,1)=(ip-1)*aa              ; coord(3,2)=coord(1,2)
      end if
      do  i=1,2
      coord(2,i)=.5*(coord(1,i)+coord(3,i))
      coord(4,i)=.5*(coord(3,i)+coord(5,i))
      coord(6,i)=.5*(coord(5,i)+coord(1,i))
      end do
      return
   end subroutine geometry_6tx
  subroutine geometry_15tyv(iel,nye,width,depth,coord,num)
!      this subroutine forms the coordinates and node vector
!      for a rectangular mesh of nonuniform 15-node triangles
!      counting in the y-direction ; local numbering clockwise
 implicit none
 real,intent(in) :: width(:),depth(:) ; real,intent(out) :: coord(:,:)
 integer, intent(in) ::  iel,nye; integer,intent(out)::num(:)
 integer::ip,iq,jel,i , fac1,fac2   
   jel = (iel - 1)/nye; ip= jel+1; iq=iel-nye*jel
    if(mod(iq,2)/=0) then
      fac1=4*(2*nye+1)*(ip-1)+2*iq-1 ; num(1)=fac1;  num(12)=fac1+1
      num(11)=fac1+2 ;  num(10)=fac1+3 ; num(9)=fac1+4 ; num(8)=fac1+2*nye+4
      num(7)=fac1+4*nye+4 ;  num(6)=fac1+6*nye+4 ;  num(5)=fac1+8*nye+4
      num(4)=fac1+6*nye+3 ;  num(3)=fac1+4*nye+2 ;  num(2)=fac1+2*nye+1
      num(13)=fac1+2*nye+2 ;  num(15)=fac1+2*nye+3  ;  num(14)=fac1+4*nye+3
      coord(1,1)=width(ip) ;  coord(1,2)=depth((iq+1)/2)
      coord(9,1)=width(ip)   ;  coord(9,2)=depth((iq+3)/2)
      coord(5,1)=width(ip+1)   ;  coord(5,2)=depth((iq+1)/2)
    else
      fac2=4*(2*nye+1)*(ip-1)+2*iq+8*nye+5 ;  num(1)=fac2 ;  num(12)=fac2-1
      num(11)=fac2-2 ;  num(10)=fac2-3 ;  num(9)=fac2-4; num(8)=fac2-2*nye-4
      num(7)=fac2-4*nye-4 ; num(6)=fac2-6*nye-4  ;  num(5)=fac2-8*nye-4
      num(4)=fac2-6*nye-3 ; num(3)=fac2-4*nye-2 ; num(2)=fac2-2*nye-1
      num(13)=fac2-2*nye-2  ; num(15)=fac2-2*nye-3 ; num(14)=fac2-4*nye-3
      coord(1,1)=width(ip+1) ;  coord(1,2)=depth((iq+2)/2)
      coord(9,1)=width(ip+1) ;  coord(9,2)=depth(iq/2)
      coord(5,1)=width(ip)   ;   coord(5,2)=depth((iq+2)/2)
    end if
    do  i=1,2
      coord(3,i)=.5*(coord(1,i)+coord(5,i))
      coord(7,i)=.5*(coord(5,i)+coord(9,i))
      coord(11,i)=.5*(coord(9,i)+coord(1,i))
      coord(2,i)=.5*(coord(1,i)+coord(3,i))
      coord(4,i)=.5*(coord(3,i)+coord(5,i))
      coord(6,i)=.5*(coord(5,i)+coord(7,i))
      coord(8,i)=.5*(coord(7,i)+coord(9,i))
      coord(10,i)=.5*(coord(9,i)+coord(11,i))
      coord(12,i)=.5*(coord(11,i)+coord(1,i))
      coord(15,i)=.5*(coord(7,i)+coord(11,i))
      coord(14,i)=.5*(coord(3,i)+coord(7,i))
      coord(13,i)=.5*(coord(2,i)+coord(15,i))
    end do
  return
 end subroutine geometry_15tyv  
!---------------------- Quadrilaterals ----------------------------------------
subroutine geometry_4qx(iel,nxe,aa,bb,coord,num)
! coordinates and nodal vectors for equal four node quad
! elements, numbering in x 
implicit none
integer,intent(in)::iel,nxe; real,intent(in)::aa,bb
real,intent(out)::coord(:,:); integer,intent(out)::num(:)
integer :: ip,iq    ; iq=(iel-1)/nxe+1; ip=iel-(iq-1)*nxe
   num=(/iq*(nxe+1)+ip,(iq-1)*(nxe+1)+ip,   &
         (iq-1)*(nxe+1)+ip+1, iq*(nxe+1)+ip+1/)
   coord(1:2,1)=(ip-1)*aa; coord(3:4,1)=ip*aa
   coord(1:4:3,2)=-iq*bb; coord(2:3,2)=-(iq-1)*bb
 return
end subroutine geometry_4qx
   subroutine geometry_4qy(iel,nye,aa,bb,coord,num)
   ! rectangles of equal 4-node quads numbered in y
   implicit none
   integer,intent(in)::iel,nye; real,intent(in)::aa,bb
   real,intent(out)::coord(:,:);integer,intent(out)::num(:)
       num=(/iel+(iel-1)/nye+1,iel+(iel-1)/nye,iel+(iel-1)/nye+nye+1,  &
             iel+(iel-1)/nye+nye+2/)
       coord(1:2,1)= aa*((iel-1)/nye); coord(3:4,1)=aa*((iel-1)/nye+1)
       coord(1:4:3,2)=-(iel-((iel-1)/nye)*nye)*bb; coord(2:3,2)=coord(1,2)+bb
     return
   end subroutine geometry_4qy              
subroutine geometry_4qyv(iel,nye,width,depth,coord,num)
!  coordinates and steering vector for a variable rectangular
!  mesh of 4-node quad elements numbering in the y-direction
  implicit none
  real,intent(in)::width(:),depth(:); integer,intent(in)::iel,nye
  real,intent(out)::coord(:,:); integer,intent(out):: num(:)
  integer:: ip,iq; ip=(iel-1)/nye+1; iq=iel-(ip-1)*nye
  num(1)=(ip-1)*(nye+1)+iq+1; num(2)=num(1)-1
  num(3)=ip*(nye+1)+iq;num(4)= num(3) + 1
  coord(1:2,1)=width(ip); coord(3:4,1)=width(ip+1)
  coord(1,2)=depth(iq+1); coord(2:3,2)=depth(iq); coord(4,2)=coord(1,2)
 return
end subroutine geometry_4qyv
subroutine geometry_8qx(iel,nxe,aa,bb,coord,num)
! coordinates and steering vector for a rectangular mesh of
! equal  8-node  elements  numbering in x
implicit none
 real,intent(out)::coord(:,:); integer,intent(out)::num(:)
 integer,intent(in)::iel,nxe; real,intent(in)::aa,bb
 integer:: ip,iq ; iq=(iel-1)/nxe+1; ip=iel-(iq-1)*nxe
 num(1)=iq*(3*nxe+2)+2*ip-1; num(2)=iq*(3*nxe+2)+ip-nxe-1
 num(3)=(iq-1)*(3*nxe+2)+2*ip-1; num(4)=num(3)+1
 num(5)=num(4)+1; num(6)=num(2)+1; num(7)=num(1)+2; num(8)=num(1)+1
 coord(1:3,1)=aa*(ip-1); coord(5:7,1)=aa*ip
 coord(4,1)=.5*(coord(3,1)+coord(5,1))
 coord(8,1)=.5*(coord(7,1)+coord(1,1))
 coord(1,2)=-bb*iq; coord(7:8,2)=-bb*iq
 coord(3:5,2)=-bb*(iq-1); coord(2,2)=.5*(coord(1,2)+coord(3,2))
 coord(6,2)=.5*(coord(5,2)+coord(7,2))  
return
end subroutine geometry_8qx
subroutine geometry_8qy(iel,nye,aa,bb,coord,num)
!  coordinates and steering vector for a constant rectangular
!  mesh of 8-node quad elements numbering in the y-direction
  implicit none
  real,intent(in):: aa,bb ; integer,intent(in):: iel,nye
  real,intent(out)::coord(:,:); integer,intent(out):: num(:)
  integer:: ip,iq; ip=(iel-1)/nye+1; iq=iel-(ip-1)*nye
  num(1)=(ip-1)*(3*nye+2)+2*iq+1; num(2)=num(1)-1; num(3)=num(1)-2
  num(4)=(ip-1)*(3*nye+2)+2*nye+iq+1;num(5)=ip*(3*nye+2)+2*iq-1
  num(6)=num(5)+1; num(7)=num(5)+2; num(8)=num(4)+1
  coord(1:3,1)=(ip-1)*aa; coord(5:7,1)=ip*aa
  coord(4,1)=.5*(coord(3,1)+coord(5,1))
  coord(8,1)=.5*(coord(7,1)+coord(1,1))
  coord(1,2)=-iq*bb; coord(7:8,2)=-iq*bb; coord(3:5,2)=-(iq-1)*bb
  coord(2,2)=.5*(coord(1,2)+coord(3,2))
  coord(6,2)=.5*(coord(5,2)+coord(7,2))
 return
end subroutine geometry_8qy
subroutine geometry_8qxv(iel,nxe,width,depth,coord,num)
! nodal coordinates and node vector for a variable mesh of
! 8-node quadrilaterals numbering in the x-direction
implicit none
  integer,intent(in)::iel,nxe;real,intent(in)::width(:),depth(:)
  real,intent(out)::coord(:,:); integer,intent(out)::num(:)                
  integer::ip,iq; iq=(iel-1)/nxe+1; ip=iel-(iq-1)*nxe
  num(1)=iq*(3*nxe+2)+2*ip-1; num(2)=iq*(3*nxe+2)+ip-nxe-1
  num(3)=(iq-1)*(3*nxe+2)+2*ip-1; num(4)=num(3)+1;num(5)=num(4)+1
  num(6)=num(2)+1; num(7)=num(1)+2; num(8)=num(1)+1
  coord(1:3,1)=width(ip); coord(5:7,1)=width(ip+1)
  coord(4,1)=.5*(coord(3,1)+coord(5,1));coord(8,1)=.5*(coord(7,1)+coord(1,1))
  coord(1,2)=depth(iq+1); coord(7:8,2)=depth(iq+1); coord(3:5,2)=depth(iq)
  coord(2,2)=.5*(coord(1,2)+coord(3,2));coord(6,2)=.5*(coord(5,2)+coord(7,2))
 return
end subroutine geometry_8qxv    
subroutine geometry_8qyv(iel,nye,width,depth,coord,num)
!  coordinates and steering vector for a variable rectangular
!  mesh of 8-node quad elements numbering in the y-direction
  implicit none
  real,intent(in)::width(:),depth(:); integer,intent(in)::iel,nye
  real,intent(out)::coord(:,:); integer,intent(out)::num(:)
  integer::ip,iq; ip=(iel-1)/nye+1; iq=iel-(ip-1)*nye
  num(1)=(ip-1)*(3*nye+2)+2*iq+1; num(2)=num(1)-1; num(3)=num(1)-2
  num(4)=(ip-1)*(3*nye+2)+2*nye+iq+1;num(5)=ip*(3*nye+2)+2*iq-1
  num(6)=num(5)+1; num(7)=num(5)+2; num(8)=num(4)+1
  coord(1:3,1)=width(ip); coord(5:7,1)=width(ip+1)
  coord(4,1)=.5*(coord(3,1)+coord(5,1))
  coord(8,1)=.5*(coord(7,1)+coord(1,1))
  coord(1,2)=depth(iq+1); coord(7:8,2)=depth(iq+1); coord(3:5,2)=depth(iq)
  coord(2,2)=.5*(coord(1,2)+coord(3,2))
  coord(6,2)=.5*(coord(5,2)+coord(7,2))
 return
end subroutine geometry_8qyv    
 subroutine geometry_9qx(iel,nxe,aa,bb,coord,num)
!      this subroutine forms the coordinates and steering vector
!      for equal 9-node Lagrangian quads counting in x-direction
 implicit none
 real,intent(out)::coord(:,:); integer,intent(out)::num(:)
 integer,intent(in)::iel,nxe; real,intent(in)::aa,bb
 integer:: ip,iq ;iq=(iel-1)/nxe+1;ip=iel-(iq-1)*nxe
   num(1)=iq*(4*nxe+2)+2*ip-1 ; num(2)=iq*(4*nxe+2)+2*ip-nxe-4
   num(3)= (iq-1)*(4*nxe+2)+2*ip-1 ;   num(4)=num(3)+1
   num(5)=num(4)+1; num(6)=num(2)+2 ;  num(7)=num(1)+2
   num(8)=num(1)+1      ;   num(9)=num(2)+1
   coord(1,1)=(ip-1)*aa  ;  coord(3,1)=(ip-1)*aa   ; coord(5,1)=ip*aa
   coord(7,1)=ip*aa ;   coord(1,2)=-iq*bb ;  coord(3,2)=-(iq-1)*bb
   coord(5,2)=-(iq-1)*bb    ;  coord(7,2)=-iq*bb
   coord(2,1)=.5*(coord(1,1)+coord(3,1)); coord(2,2)=.5*(coord(1,2)+coord(3,2))
   coord(4,1)=.5*(coord(3,1)+coord(5,1)); coord(4,2)=.5*(coord(3,2)+coord(5,2))
   coord(6,1)=.5*(coord(5,1)+coord(7,1)); coord(6,2)=.5*(coord(5,2)+coord(7,2))
   coord(8,1)=.5*(coord(1,1)+coord(7,1)); coord(8,2)=.5*(coord(1,2)+coord(7,2))
   coord(9,1)=.5*(coord(2,1)+coord(6,1)); coord(9,2)=.5*(coord(4,2)+coord(8,2))
  return
 end subroutine geometry_9qx  
!-----------------------Hexahedra "Bricks" ------------------------------------
 subroutine geometry_8bxz(iel,nxe,nze,aa,bb,cc,coord,num)
!      this subroutine forms the coordinates and nodal vector
!      for boxes of 8-node brick elements counting x-z planes in y-direction
 implicit none
   integer,intent(in)::iel,nxe,nze;integer,intent(out)::num(:)
   real,intent(in)::aa,bb,cc; real,intent(out)::coord(:,:)
   integer::ip,iq,is,iplane
   iq=(iel-1)/(nxe*nze)+1 ; iplane = iel -(iq-1)*nxe*nze
   is=(iplane-1)/nxe+1; ip = iplane-(is-1)*nxe   
   num(1)=(iq-1)*(nxe+1)*(nze+1)+is*(nxe+1)+ip ;  num(2)=num(1)-nxe-1
   num(3)=num(2)+1 ;   num(4)=num(1)+1 ; num(5)=num(1)+(nxe+1)*(nze+1)
   num(6)=num(5)-nxe-1 ;   num(7)=num(6)+1    ;   num(8)=num(5)+1
   coord(1,1)=(ip-1)*aa ; coord(2,1)=(ip-1)*aa ;  coord(5,1)=(ip-1)*aa
   coord(6,1)=(ip-1)*aa ; coord(3,1)=ip*aa ;   coord(4,1)=ip*aa
   coord(7,1)=ip*aa   ;   coord(8,1)=ip*aa
   coord(1,2)=(iq-1)*bb  ;   coord(2,2)=(iq-1)*bb ; coord(3,2)=(iq-1)*bb
   coord(4,2)=(iq-1)*bb  ;   coord(5,2)=iq*bb  ;    coord(6,2)=iq*bb
   coord(7,2)=iq*bb ;    coord(8,2)=iq*bb ;   coord(1,3)=-is*cc
   coord(4,3)=-is*cc  ;   coord(5,3)=-is*cc ;   coord(8,3)=-is*cc
   coord(2,3)=-(is-1)*cc ; coord(3,3)=-(is-1)*cc  ;  coord(6,3)=-(is-1)*cc
   coord(7,3)=-(is-1)*cc 
  return
 end subroutine geometry_8bxz                     
subroutine geometry_20bxz(iel,nxe,nze,aa,bb,cc,coord,num)
! nodal vector and nodal coordinates for boxes of 20-node
! bricks counting x-z planes in the y-direction
implicit none
  integer,intent(in)::iel,nxe,nze; real,intent(in)::aa,bb,cc
  real,intent(out)::coord(:,:); integer,intent(out)::num(:)
  integer::fac1,fac2,ip,iq,is,iplane
  iq = (iel-1)/(nxe*nze)+1; iplane = iel-(iq-1)*nxe*nze
  is = (iplane-1)/nxe+1 ; ip = iplane-(is-1)*nxe
  fac1=((2*nxe+1)*(nze+1)+(2*nze+1)*(nxe+1))*(iq-1)
  fac2=((2*nxe+1)*(nze+1)+(2*nze+1)*(nxe+1))*iq
  num(1)=fac1+(3*nxe+2)*is+2*ip-1
  num(2)=fac1+(3*nxe+2)*is-nxe+ip-1; num(3)=num(1)-3*nxe-2
  num(4)=num(3)+1; num(5)=num(4)+1; num(6)=num(2)+1
  num(7)=num(1)+2; num(8)=num(1)+1
  num(9)=fac2-(nxe+1)*(nze+1)+(nxe+1)*is+ip
  num(10)=num(9)-nxe-1; num(11)=num(10)+1; num(12)=num(9)+1
  num(13)=fac2+(3*nxe+2)*is+2*ip-1
  num(14)=fac2+(3*nxe+2)*is-nxe+ip-1
  num(15)=num(13)-3*nxe-2; num(16)=num(15)+1; num(17)=num(16)+1
  num(18)=num(14)+1; num(19)=num(13)+2; num(20)=num(13)+1 
  coord(1:3,1)=(ip-1)*aa; coord(9:10,1)=(ip-1)*aa; coord(13:15,1)=(ip-1)*aa
  coord(5:7,1)=ip*aa; coord(11:12,1)=ip*aa; coord(17:19,1)=ip*aa
  coord(4,1)=.5*(coord(3,1)+coord(5,1));coord(8,1)=.5*(coord(1,1)+coord(7,1))
  coord(16,1)=.5*(coord(15,1)+coord(17,1))
  coord(20,1)=.5*(coord(13,1)+coord(19,1))
  coord(1:8,2)=(iq-1)*bb; coord(13:20,2)=iq*bb
  coord(9,2)=.5*(coord(1,2)+coord(13,2))
  coord(10,2)=.5*(coord(3,2)+coord(15,2))
  coord(11,2)=.5*(coord(5,2)+coord(17,2))
  coord(12,2)=.5*(coord(7,2)+coord(19,2))
  coord(1,3)=-is*cc; coord(7:9,3)=-is*cc; coord(12:13,3)=-is*cc
  coord(19:20,3)=-is*cc; coord(3:5,3)=-(is-1)*cc
  coord(10:11,3)=-(is-1)*cc; coord(15:17,3)=-(is-1)*cc
  coord(2,3)=.5*(coord(1,3)+coord(3,3))
  coord(6,3)=.5*(coord(5,3)+coord(7,3))
  coord(14,3)=.5*(coord(13,3)+coord(15,3))
  coord(18,3)=.5*(coord(17,3)+coord(19,3))
 return
end subroutine geometry_20bxz
!--------------------Special purpose geometries  ------------------------------
 subroutine slope_geometry(iel,nye,top,bot,depth,coord,num)
!    this subroutine forms the coordinates and steering vector
!    for 8-node quadrilaterals in a 'slope' geometry
!    (numbering in the y-direction)
 implicit none
  real,intent(in):: top(:),bot(:),depth(:); real,intent(out)::coord(:,:)
  integer,intent(in):: iel,nye; integer,intent(out)::num(:)
  real :: fac1 , fac2  ; integer :: ip,iq  
   ip = (iel-1)/nye+1 ; iq = iel-(ip-1)*nye
   num(1)=(ip-1)*(3*nye+2)+2*iq+1 ;num(2)=num(1)-1  ;  num(3)=num(1)-2
   num(4)=(ip-1)*(3*nye+2)+2*nye+iq+1 ;  num(5)=ip*(3*nye+2)+2*iq-1
   num(6)=num(5)+1;   num(7)=num(5)+2   ;   num(8)=num(4)+1
   fac1=(bot(ip)-top(ip))/nye ;  fac2=(bot(ip+1)-top(ip+1))/nye
   coord(1,1)=top(ip)+iq*fac1;   coord(3,1)=top(ip)+(iq-1)*fac1
   coord(5,1)=top(ip+1)+(iq-1)*fac2; coord(7,1)=top(ip+1)+iq*fac2
   coord(2,1)=.5*(coord(1,1)+coord(3,1)); coord(6,1)=.5*(coord(5,1)+coord(7,1))
   coord(4,1)=.5*(coord(3,1)+coord(5,1)); coord(8,1)=.5*(coord(7,1)+coord(1,1))
   coord(1,2)=depth(iq+1); coord(8,2)=depth(iq+1); coord(7,2)=depth(iq+1)
   coord(3,2)=depth(iq) ;  coord(4,2)=depth(iq)  ; coord(5,2)=depth(iq)
   coord(2,2)=.5*(coord(1,2)+coord(3,2)); coord(6,2)=.5*(coord(5,2)+coord(7,2))
  return
 end subroutine slope_geometry    
subroutine geometry_freesurf(iel,nxe,fixed_seep,fixed_down,down,&
                             width,angs,surf,coord,num)
!             this subroutine forms the coordinates and steering vector
!             for 4-node quads numbering in the x-direction
!             (Laplace's equation, variable mesh, 1-freedom per node)
implicit none
real,intent(in)::width(:),angs(:),surf(:),down ;real,intent(out)::coord(:,:)
integer,intent(in)::iel,nxe,fixed_seep,fixed_down;integer,intent(out)::num(:)
real::angr(size(angs)),pi,b1,b2,tan1,tan2,fac1,fac2
integer::ip,iq
 pi=acos(-1.0); angr=angs*pi/180.    ; iq=(iel-1)/nxe+1; ip=iel-(iq-1)*nxe
 num(1)=iq*(nxe+1)+ip; num(2)=(iq-1)*(nxe+1)+ip
 num(3)=num(2)+1; num(4)=num(1)+1
 if(iq <= fixed_seep+1)then
 b1=(surf(ip)-down)/real(fixed_seep+1); b2=(surf(ip+1)-down)/real(fixed_seep+1)
 coord(1,2)=down+(fixed_seep+1-iq)*b1 ; coord(2,2)=down+(fixed_seep+2-iq)*b1
 coord(3,2)=down+(fixed_seep+2-iq)*b2 ; coord(4,2)=down+(fixed_seep+1-iq)*b2
 else
 b1=real(fixed_down+fixed_seep-iq)/real(fixed_down-1) 
 b2=real(fixed_down+fixed_seep-iq+1)/real(fixed_down-1) 
 coord(1,2)=down*b1;    coord(2,2)=down*b2
 coord(3,2)=coord(2,2); coord(4,2)=coord(1,2)
 end if
if(abs(angr(ip)-pi*.5) < 0.0001)then
  fac1=0.
else
 tan1=tan(angr(ip))      ; fac1=1.0/tan1
end if
if(abs(angr(ip+1)-pi*.5) < 0.0001)then
  fac2=0.
else
 tan2=tan(angr(ip+1))    ; fac2=1.0/tan2 
end if
 coord(1,1)=width(ip) +coord(1,2)*fac1 ; coord(2,1)=width(ip)  +coord(2,2)*fac1
 coord(3,1)=width(ip+1)+coord(3,2)*fac2 ;coord(4,1)=width(ip+1)+coord(4,2)*fac2
return
end subroutine geometry_freesurf                                               
!---------------------Construction and excavation -----------------------------
 subroutine fmglem(fnxe,fnye,lnxe,lnye,g_num,lifts)
 ! returns g_num for the mesh
 implicit none
 integer,intent(in)::fnxe,fnye,lnxe,lnye,lifts;integer,intent(out)::g_num(:,:)
 integer::ig,i,j,ii,ilast       ; ig = 0
 do i=1,fnye; do j=1,fnxe
  ig = ig + 1
  g_num(1,ig)=(j*2-1)+(i-1)*(fnxe+1)+(i-1)*(2*fnxe+1)
  g_num(8,ig) = g_num(1,ig)+1; g_num(7,ig) = g_num(1,ig)+2
  g_num(2,ig)=i*(2*fnxe+1)+j+(i-1)*(fnxe+1)
  g_num(6,ig)=g_num(2,ig)+1
  g_num(3,ig)=i*(2*fnxe+1)+i*(fnxe+1)+(j*2-1)
  g_num(4,ig)=g_num(3,ig)+1; g_num(5,ig)=g_num(3,ig)+2
 end do; end do
  ilast=g_num(5,ig)
  do ii = 1 , lifts - 1
    do i=1,lnye; do j=1,lnxe-(ii-1)*1
      ig = ig + 1
      g_num(1,ig)=ilast-(lnxe-ii+1)*2+(j-1)*2
      g_num(8,ig) = g_num(1,ig)+1; g_num(7,ig) = g_num(1,ig)+2
      g_num(2,ig)=ilast+j
      g_num(6,ig)=g_num(2,ig)+1
      g_num(3,ig)=ilast+(lnxe-ii+1)+1+(j*2-1)
      g_num(4,ig)=g_num(3,ig)+1; g_num(5,ig)=g_num(3,ig)+2
    end do; end do
    ilast=g_num(5,ig)
  end do
 return
 end subroutine fmglem
 subroutine fmcoem(g_num,g_coord,fwidth,fdepth,width,depth,           &
                   lnxe,lifts,fnxe,fnye,itype)
 ! returns g_coord for the mesh
 implicit none
 integer,intent(in)::g_num(:,:),lnxe,lifts,fnxe,fnye,itype
 real,intent(out)::g_coord(:,:);integer::ig,i,j,ii,lnye
 real,intent(in)::fwidth(:),fdepth(:),width(:),depth(:)
 lnye = 1; ig = 0
 do i=1,fnye; do j=1,fnxe
 ig = ig + 1
 g_coord(1,g_num(1,ig))=fwidth(j); g_coord(1,g_num(2,ig))=fwidth(j)
 g_coord(1,g_num(3,ig))=fwidth(j); g_coord(1,g_num(5,ig))=fwidth(j+1)
 g_coord(1,g_num(6,ig))=fwidth(j+1); g_coord(1,g_num(7,ig))=fwidth(j+1)
 g_coord(1,g_num(4,ig))=0.5*(g_coord(1,g_num(3,ig))+g_coord(1,g_num(5,ig)))
 g_coord(1,g_num(8,ig))=0.5*(g_coord(1,g_num(1,ig))+g_coord(1,g_num(7,ig)))
 g_coord(2,g_num(1,ig))=fdepth(i); g_coord(2,g_num(8,ig))=fdepth(i)
 g_coord(2,g_num(7,ig))=fdepth(i); g_coord(2,g_num(3,ig))=fdepth(i+1)
 g_coord(2,g_num(4,ig))=fdepth(i+1); g_coord(2,g_num(5,ig))=fdepth(i+1)
 g_coord(2,g_num(2,ig))=0.5*(g_coord(2,g_num(1,ig))+g_coord(2,g_num(3,ig)))
 g_coord(2,g_num(6,ig))=0.5*(g_coord(2,g_num(7,ig))+g_coord(2,g_num(5,ig)))
 end do; end do
 if(itype==1) then
 do ii = 1 , lifts - 1
  do i=1,lnye; do j=1,lnxe-(ii-1)*1
   ig = ig + 1
   if(j==1) then
    g_coord(1,g_num(1,ig))=width((ii-1)+j)
    g_coord(1,g_num(5,ig))=width((ii-1)+j+1)
    g_coord(1,g_num(6,ig))=g_coord(1,g_num(5,ig))
    g_coord(1,g_num(7,ig))=g_coord(1,g_num(5,ig))
    g_coord(1,g_num(3,ig))=0.5*(g_coord(1,g_num(1,ig))+g_coord(1,g_num(5,ig)))
    g_coord(1,g_num(2,ig))=0.5*(g_coord(1,g_num(3,ig))+g_coord(1,g_num(1,ig)))
    g_coord(1,g_num(4,ig))=0.5*(g_coord(1,g_num(3,ig))+g_coord(1,g_num(5,ig)))
    g_coord(1,g_num(8,ig))=0.5*(g_coord(1,g_num(1,ig))+g_coord(1,g_num(7,ig)))
    g_coord(2,g_num(1,ig))=depth((ii-1)+i)
    g_coord(2,g_num(8,ig))=depth((ii-1)+i)
    g_coord(2,g_num(7,ig))=depth((ii-1)+i)
    g_coord(2,g_num(5,ig))=depth((ii-1)+i+1)
    g_coord(2,g_num(3,ig))=0.5*(g_coord(2,g_num(1,ig))+g_coord(2,g_num(5,ig)))
    g_coord(2,g_num(2,ig))=0.5*(g_coord(2,g_num(1,ig))+g_coord(2,g_num(3,ig)))
    g_coord(2,g_num(4,ig))=0.5*(g_coord(2,g_num(3,ig))+g_coord(2,g_num(5,ig)))
    g_coord(2,g_num(6,ig))=0.5*(g_coord(2,g_num(5,ig))+g_coord(2,g_num(7,ig)))
   else
    g_coord(1,g_num(1,ig))=width((ii-1)+j)
    g_coord(1,g_num(2,ig))=width((ii-1)+j)
    g_coord(1,g_num(3,ig))=width((ii-1)+j)
    g_coord(1,g_num(5,ig))=width((ii-1)+j+1)
    g_coord(1,g_num(6,ig))=width((ii-1)+j+1)
    g_coord(1,g_num(7,ig))=width((ii-1)+j+1)
    g_coord(1,g_num(4,ig))=0.5*(g_coord(1,g_num(3,ig))+g_coord(1,g_num(5,ig)))
    g_coord(1,g_num(8,ig))=0.5*(g_coord(1,g_num(1,ig))+g_coord(1,g_num(7,ig)))
    g_coord(2,g_num(1,ig))=depth((ii-1)+i)
    g_coord(2,g_num(8,ig))=depth((ii-1)+i)
    g_coord(2,g_num(7,ig))=depth((ii-1)+i)
    g_coord(2,g_num(3,ig))=depth((ii-1)+i+1)
    g_coord(2,g_num(4,ig))=depth((ii-1)+i+1)
    g_coord(2,g_num(5,ig))=depth((ii-1)+i+1)
    g_coord(2,g_num(2,ig))=0.5*(g_coord(2,g_num(1,ig))+g_coord(2,g_num(3,ig)))
    g_coord(2,g_num(6,ig))=0.5*(g_coord(2,g_num(5,ig))+g_coord(2,g_num(7,ig)))
  end if
  end do; end do
 end do
 else
 do ii = 1 , lifts - 1
  do i=1,lnye; do j=1,lnxe-(ii-1)*1
   ig = ig + 1
   if(j==1) then
    g_coord(1,g_num(1,ig))=width((ii-1)+j)
    g_coord(1,g_num(5,ig))=width((ii-1)+j+1)
    g_coord(1,g_num(6,ig))=g_coord(1,g_num(5,ig))
    g_coord(1,g_num(7,ig))=g_coord(1,g_num(5,ig))
    g_coord(1,g_num(3,ig))=g_coord(1,g_num(5,ig))
    g_coord(1,g_num(4,ig))=g_coord(1,g_num(5,ig))
    g_coord(1,g_num(8,ig))=0.5*(g_coord(1,g_num(1,ig))+g_coord(1,g_num(7,ig)))
    g_coord(1,g_num(2,ig))=0.5*(g_coord(1,g_num(1,ig))+g_coord(1,g_num(5,ig)))
    g_coord(2,g_num(1,ig))=depth((ii-1)+i)
    g_coord(2,g_num(8,ig))=depth((ii-1)+i)
    g_coord(2,g_num(7,ig))=depth((ii-1)+i)
    g_coord(2,g_num(5,ig))=depth((ii-1)+i+1)
    g_coord(2,g_num(2,ig))=0.5*(g_coord(2,g_num(1,ig))+g_coord(2,g_num(5,ig)))
    g_coord(2,g_num(6,ig))=0.5*(g_coord(2,g_num(5,ig))+g_coord(2,g_num(7,ig)))
    g_coord(2,g_num(3,ig))=g_coord(2,g_num(5,ig))
    g_coord(2,g_num(4,ig))=g_coord(2,g_num(5,ig))
   else
    g_coord(1,g_num(1,ig))=width((ii-1)+j)
    g_coord(1,g_num(2,ig))=width((ii-1)+j)
    g_coord(1,g_num(3,ig))=width((ii-1)+j)
    g_coord(1,g_num(5,ig))=width((ii-1)+j+1)
    g_coord(1,g_num(6,ig))=width((ii-1)+j+1)
    g_coord(1,g_num(7,ig))=width((ii-1)+j+1)
    g_coord(1,g_num(4,ig))=0.5*(g_coord(1,g_num(3,ig))+g_coord(1,g_num(5,ig)))
    g_coord(1,g_num(8,ig))=0.5*(g_coord(1,g_num(1,ig))+g_coord(1,g_num(7,ig)))
    g_coord(2,g_num(1,ig))=depth((ii-1)+i)
    g_coord(2,g_num(8,ig))=depth((ii-1)+i)
    g_coord(2,g_num(7,ig))=depth((ii-1)+i)
    g_coord(2,g_num(3,ig))=depth((ii-1)+i+1)
    g_coord(2,g_num(4,ig))=depth((ii-1)+i+1)
    g_coord(2,g_num(5,ig))=depth((ii-1)+i+1)
    g_coord(2,g_num(2,ig))=0.5*(g_coord(2,g_num(1,ig))+g_coord(2,g_num(3,ig)))
    g_coord(2,g_num(6,ig))=0.5*(g_coord(2,g_num(5,ig))+g_coord(2,g_num(7,ig)))
  end if
  end do; end do
 end do
 end if
 return
end subroutine fmcoem                       
 subroutine fmglob(nxe,nye,g_num)
 ! returns g_num for the mesh
 implicit none
 integer,intent(in)::nxe,nye;integer,intent(out)::g_num(:,:)
 integer::ig,i,j       ; ig = 0
 do i=1,nye; do j=1,nxe
  ig = ig + 1
  g_num(1,ig)=(j*2-1)+(i-1)*(nxe+1)+(i-1)*(2*nxe+1)
  g_num(8,ig) = g_num(1,ig)+1; g_num(7,ig) = g_num(1,ig)+2
  g_num(2,ig)=i*(2*nxe+1)+j+(i-1)*(nxe+1)
  g_num(6,ig)=g_num(2,ig)+1
  g_num(3,ig)=i*(2*nxe+1)+i*(nxe+1)+(j*2-1)
  g_num(4,ig)=g_num(3,ig)+1; g_num(5,ig)=g_num(3,ig)+2
 end do; end do
 return
 end subroutine fmglob
 subroutine fmcoco(g_num,g_coord,width,depth,nxe,nye)
 ! returns g_coord for the mesh
 implicit none
 integer,intent(in)::g_num(:,:),nxe,nye
 real,intent(out)::g_coord(:,:);integer::ig,i,j
 real,intent(in)::width(:),depth(:)
 ig = 0
 do i=1,nye; do j=1,nxe
 ig = ig + 1
 g_coord(1,g_num(1,ig))=width(j); g_coord(1,g_num(2,ig))=width(j)
 g_coord(1,g_num(3,ig))=width(j); g_coord(1,g_num(5,ig))=width(j+1)
 g_coord(1,g_num(6,ig))=width(j+1); g_coord(1,g_num(7,ig))=width(j+1)
 g_coord(1,g_num(4,ig))=0.5*(g_coord(1,g_num(3,ig))+g_coord(1,g_num(5,ig)))
 g_coord(1,g_num(8,ig))=0.5*(g_coord(1,g_num(1,ig))+g_coord(1,g_num(7,ig)))
 g_coord(2,g_num(1,ig))=depth(i); g_coord(2,g_num(8,ig))=depth(i)
 g_coord(2,g_num(7,ig))=depth(i); g_coord(2,g_num(3,ig))=depth(i+1)
 g_coord(2,g_num(4,ig))=depth(i+1); g_coord(2,g_num(5,ig))=depth(i+1)
 g_coord(2,g_num(2,ig))=0.5*(g_coord(2,g_num(1,ig))+g_coord(2,g_num(3,ig)))
 g_coord(2,g_num(6,ig))=0.5*(g_coord(2,g_num(7,ig))+g_coord(2,g_num(5,ig)))
 end do; end do
 return
end subroutine fmcoco 
end module geometry_lib    
