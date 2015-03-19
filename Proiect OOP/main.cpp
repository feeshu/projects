#include "Rational.h"
#include "Rational.cpp"
#include <iostream>
#include <cmath>
#include <stdlib.h>



int main()
{
  /*  Rational a1,b1,c1,a2,b2,c2,a,b,c,d,e,f;
    float det1,det2,det3,x,y;
    bool dinNou = true;
    char daNu;

    while (dinNou == true){

    cout << "a=" << endl;
    a.citireFractie();
    cout << "b=" << endl;
    b.citireFractie();
    cout << "c=" << endl;
    c.citireFractie();
    cout << "d=" << endl;
    d.citireFractie();
    cout << "e=" << endl;
    e.citireFractie();
    cout << "f=" << endl;
    f.citireFractie();

    system("cls");

    cout << "Valorile sunt:" << endl;
    cout << "a = "; a.afisFractie(); cout << " ; ";
    cout << "b = "; b.afisFractie(); cout << " ; ";
    cout << "c = "; c.afisFractie(); cout << " ; ";
    cout << "d = "; d.afisFractie(); cout << " ; ";
    cout << "e = "; e.afisFractie(); cout << " ; ";
    cout << "f = "; f.afisFractie();

    cout << endl << endl << "*****************************";

    cout << endl << endl << "Sistemul de ecuatii este: " << endl << endl;
    a.afisFractie(); cout << "x+"; b.afisFractie(); cout << "y="; c.afisFractie(); cout << endl;
    d.afisFractie(); cout << "x+"; e.afisFractie(); cout << "y="; f.afisFractie(); cout << endl;

    cout << endl << "*****************************" << endl << endl;

    det1=a*e-d*b;
    det2=c*e-f*b;
    det3=a*f-d*c;

   if(det1==0) {
    if(a==0 && d==0) {
        if(b==0 && e==0){
            if(c==0 && f==0) {
            cout << "x, y au o infinitate de solutii." << endl;
            return 0;
            }
        else cout << "Sistemul nu are solutii." << endl;
        return 0;
        }
        if(b==0){
            if(c!=0) {
                cout << "Sistemul nu are solutii." << endl;
                return 0;
            }
            else cout << "x are o infinitate de solutii; y = " << f/e << endl;
            return 0;
        }
        if(e==0){
            if(f!=0) {
                cout << "Sistemul nu are solutii." << endl;
                return 0;
            }
            else cout << "x are o infinitate de solutii; y = " << f/e << endl;
            return 0;
        }
    }

    if(b==0 && e==0) {
        if(a==0 && d==0) {
            if(c==0 && f==0) {
                cout << "x, y au o infinitate de solutii." << endl;
                return 0;
            }
            else cout << "Sistemul nu are solutii." << endl;
            return 0;
        }
        if(a==0) {
            if(c!=0) {
                cout << "Sistemul nu are solutii." << endl;
                return 0;
            }
            else cout << "x are o infinitate de solutii; y = " << f/e << endl;
            return 0;
        }

        if(d==0) {
            if(f!=0){
                cout << "Sistemul nu are solutii." << endl;
                return 0;
            }
            else cout << "x are o infinitate de solutii; y = " << f/e << endl;
            return 0;
        }
    }
   }


     if(det1!=0){
        cout << "Sistemul este compatibil determinat." << endl << endl;

        x = (float)(det2/det1);
        y = (float)(det3/det1);

        cout << "x = " << x << endl;
        cout << "y = " << y << endl;
     }


    cout << endl << "Alegeti alt sistem? [d/n]" << endl;
    cin >> daNu;
    if (daNu == 'd' || daNu == 'D') {
        system("cls");
        dinNou = true;
    }
    else if (daNu == 'n' || daNu == 'N')
        dinNou = false;
    }
}

*/

Rational a(6,3), b(3,5);
if(1<a)
cout << "asd";
else cout << "aqqqq";

}

