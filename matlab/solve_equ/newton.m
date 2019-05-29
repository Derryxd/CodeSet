function newton()
    syms x1 x2 x3 x4
    f=(x1+2*x2)^2+3*(x3-x4)^2+(x2-2*x3)^2+2*(x1-x4)^2+9;
    v=[x1,x2,x3,x4];
    df=jacobian(f,v);
    df=df.';
    df
    G=jacobian(df,v);
    G
    epson=1e-4;
    xm=[1,1,1,1]';
    gl=subs(df,{x1,x2,x3,x4},{xm(1,1),xm(2,1),xm(3,1),xm(4,1)});
    Gl=subs(G,{x1,x2,x3,x4},{xm(1,1),xm(2,1),xm(3,1),xm(4,1)});
    k=0;
    while(norm(gl)>epson)
        xm=xm-inv(Gl)*gl;
        gl=subs(df,{x1,x2,x3,x4},{xm(1,1),xm(2,1),xm(3,1),xm(4,1)});
        Gl=subs(G,{x1,x2,x3,x4},{xm(1,1),xm(2,1),xm(3,1),xm(4,1)});
        k=k+1;
    end
    k
    xm'
end