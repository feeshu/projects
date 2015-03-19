#include "Rational.h"
#include <iostream>
#include <cmath>
#include <stdlib.h>


using namespace std;

Rational::Rational() //constructor initializare
{
    numarator = 0;
    numitor = 1;
}

Rational::Rational(int n, int d) // constructor initializare
{
    int setNumarator(n);
    int setNumitor(d);
}

Rational::Rational(Rational const &copy)
{
    numitor=copy.numitor;
    numarator=copy.numarator;
}

void Rational::simplFractie() // metoda simplificare fractie
{
    int k;
    bool redus = true;

    do{
        if((numarator>=2)&&(numitor>=2)){
            for(k=2; k<=numarator; k++){
                if((numarator%k==0) && (numitor%k==0)){
                    numarator = (numarator/k);
                    numitor = (numitor/k);
                    bool redus = false;
                }
            }
        }
    }
    while(!redus);
}

void Rational::setNumarator(int n) // metoda furnizare numarator
{
    cin >> n;
    cout << "/" << endl;
    numarator = n;
}

void Rational::setNumitor(int d) // metoda furnizare numitor
{
    cin >> d;
    if(d==0){
        cout << "Nu se poate imparti la 0. Numitorul va fi initializat automat cu valoarea 1." << endl << endl;
        numitor = 1;
    }
    else
        numitor = d;
}

void Rational::citireFractie() // metoda citire fractie
{
    setNumarator(numarator);
    setNumitor(numitor);
}

void Rational::afisFractie() // metoda afisare fractie
{
        if(numarator%numitor!=0) cout << numarator << "/" << numitor;
        else cout << numarator/numitor;

}

Rational::operator double()
{
    return numarator/(double)numitor;
}

Rational operator+(Rational a, Rational b)
{
    Rational c;

    c.numarator = a.numarator*b.numitor+a.numitor*b.numarator;
    c.numitor = a.numitor*b.numitor;

    c.simplFractie();

    return c;
}

Rational operator+(Rational a, int b)
{
   Rational c;

   c.numarator = a.numarator + b*a.numitor;
   c.numitor = a.numitor;

   c.simplFractie();

   return c;
}

Rational operator+(int a, Rational b)
{
    Rational c;

    c.numarator = a*b.numitor + b.numarator;
    c.numitor = b.numitor;

    c.simplFractie();

    return c;
}

Rational operator-(Rational a, Rational b)
{
    Rational c;

    c.numarator = a.numarator*b.numitor-a.numitor*b.numarator;
    c.numitor = a.numitor*b.numitor;

    c.simplFractie();

    return c;
}

Rational operator- (Rational a, int b)
{
   Rational c;

   c.numarator = a.numarator - b*a.numitor;
   c.numitor = a.numitor;

   c.simplFractie();

   return c;
}

Rational operator- (int a, Rational b)
{
    Rational c;

    c.numarator = a*b.numitor - b.numarator;
    c.numitor = b.numitor;

    c.simplFractie();

    return c;
}

Rational  operator* (Rational a, Rational b)
{
    Rational c;

    c.numarator = a.numarator*b.numarator;
    c.numitor = a.numitor*b.numitor;

    c.simplFractie();

    return c;
}

Rational operator* (Rational a, int b)
{
    Rational c;

    c.numarator = a.numarator * b;
    c.numitor = a.numitor;

    c.simplFractie();

    return c;
}

Rational operator* (int a, Rational b)
{
    Rational c;

    c.numarator = a * b.numarator;
    c.numitor = b.numitor;

    c.simplFractie();

    return c;
}

Rational operator/ (Rational a, Rational b)
{
    Rational c;

    c.numarator = a.numarator * b.numitor;
    c.numitor = a.numitor * b.numarator;

    c.simplFractie();

    return c;
}

Rational operator/ (Rational a, int b)
{
    Rational c;

    c.numarator = a.numarator;
    c.numitor = a.numitor*b;

    c.simplFractie();

    return c;
}

Rational operator/ (int a, Rational b)
{
    Rational c;

    c.numarator = a * b.numitor;
    c.numitor = b.numarator;

    c.simplFractie();

    return c;
}

Rational &operator+= (Rational &a, Rational b)
{
    a.numarator = a.numarator*b.numitor + b.numarator*a.numitor;
    a.numitor = a.numitor*b.numitor;

    a.simplFractie();

    return a;
}

Rational &operator+= (Rational &a, int b)
{
    a.numarator = a.numarator + b*a.numitor;

    a.simplFractie();

    return a;
}

Rational &operator*= (Rational &a, Rational b)
{
    a.numarator *= b.numarator;
    a.numitor *= b.numitor;

    a.simplFractie();

    return a;
}

Rational &operator*= (Rational &a, int b)
{
    a.numarator = b*a.numarator;

    a.simplFractie();

    return a;
}

Rational &operator-= (Rational &a, Rational b)
{
    a.numarator = a.numarator*b.numitor - b.numarator*a.numitor;
    a.numitor = a.numitor*b.numitor;

    a.simplFractie();

    return a;
}

Rational &operator-= (Rational &a, int b)
{
    a.numarator = a.numarator - b*a.numitor;

    a.simplFractie();

    return a;
}

Rational &operator/= (Rational &a, int b)
{
    a.numitor = a.numitor * b;

    a.simplFractie();

    return a;
}

Rational &operator/= (Rational &a, Rational b)
{
    a.numarator = a.numarator * b.numitor;
    a.numitor = a.numitor * b.numarator;

    a.simplFractie();

    return a;
}

int operator== (Rational a, Rational b)
{
    if(a.numitor * b.numarator == a.numarator*b.numitor)
        return 1;
    else return 0;
}

int operator== (Rational a, int b)
{
    if(b*a.numitor == a.numarator)
        return 1;
    else return 0;
}

int operator== (int a, Rational b)
{
    if(a*b.numitor == b.numarator)
        return 1;
    else return 0;
}

int operator!= (Rational a, Rational b)
{
    if(a.numitor*b.numarator != a.numarator*b.numitor)
        return 1;
    else return 0;
}

int operator!= (Rational a, int b)
{
    if(a.numitor*b != a.numarator)
        return 1;
    else return 0;
}

int operator!= (int a, Rational b)
{
    if(b.numarator != b.numitor*a)
        return 1;
    else return 0;
}

int operator< (Rational a, Rational b)
{
    if(a.numitor*b.numarator < a.numarator*b.numitor)
        return 1;
    else return 0;
}

int operator< (Rational a, int b)
{
    if (a.numarator < a.numitor*b)
        return 1;
    else return 0;
}

int operator< (int a, Rational b)
{
    if (b.numarator < b.numitor*a)
        return 1;
    else return 0;
}

int operator<= (Rational a, Rational b)
{
    if(a.numitor*b.numarator <= a.numarator*b.numitor)
        return 1;
    else return 0;
}

int operator<= (Rational a, int b)
{
    if (a.numarator <= a.numitor*b)
        return 1;
    else return 0;
}

int operator<= (int a, Rational b)
{
    if (b.numarator <= b.numitor*a)
        return 1;
    else return 0;
}

int operator> (Rational a, Rational b)
{
    if(a.numitor*b.numarator > a.numarator*b.numitor)
        return 1;
    else return 0;
}

int operator> (Rational a, int b)
{
    if (a.numarator > a.numitor*b)
        return 1;
    else return 0;
}

int operator> (int a, Rational b)
{
    if (b.numarator > b.numitor*a)
        return 1;
    else return 0;
}

int operator>= (Rational a, Rational b)
{
    if(a.numitor*b.numarator >= a.numarator*b.numitor)
        return 1;
    else return 0;
}

int operator>= (Rational a, int b)
{
    if (a.numarator >= a.numitor*b)
        return 1;
    else return 0;
}

int operator>= (int a, Rational b)
{
    if (b.numarator >= b.numitor*a)
        return 1;
    else return 0;
}

Rational &operator^ (Rational &a, int b)
{
    Rational *c;
    if(b==0)
    {
        c=new Rational(1,1);
        return *c;
    }

    (*c)=a*a;
    if(b==1) return a;
    if(b==2) return *c;

    for(int i=3; i<=b; i++)
    {
        (*c)=(*c)*a;
        return *c;
    }
}

Rational abs(Rational a)
{
    if(a.numarator<0)
        a.numarator = a.numarator * (-1);
    else if (a.numitor<0)
        a.numitor = a.numitor * (-1);

    return a;
}
