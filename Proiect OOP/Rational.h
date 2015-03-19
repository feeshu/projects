#ifndef RATIONAL_H
#define RATIONAL_H

#include <iostream>
#include <cmath>

using namespace std;


class Rational{
    private:
        int numarator;
        int numitor;
        void simplFractie();

    public:
        int n,d;
        Rational(); // constructor initializare
        Rational(int, int); // constructor initializare
        Rational(Rational const&); //constructor copiere
        void setNumitor(int);
        void setNumarator(int);
        void citireFractie();
        void afisFractie();

        operator double();

        friend Rational operator+ (Rational, Rational) ;
        friend Rational operator+ (Rational, int);
        friend Rational operator+ (int,  Rational);

        friend Rational operator- (Rational, Rational);
        friend Rational operator- (Rational, int);
        friend Rational operator- (int,  Rational);

        friend Rational operator* (Rational, Rational);
        friend Rational operator* (Rational, int);
        friend Rational operator* (int,  Rational);

        friend Rational operator/ (Rational, Rational);
        friend Rational operator/ (Rational, int);
        friend Rational operator/ (int,  Rational);

        friend Rational &operator+= (Rational&, Rational);
        friend Rational &operator+= (Rational&, int);

        friend Rational &operator-= (Rational&, Rational);
        friend Rational &operator-= (Rational&, int);

        friend Rational &operator*= (Rational&, Rational);
        friend Rational &operator*= (Rational&, int);

        friend Rational &operator/= (Rational&, Rational);
        friend Rational &operator/= (Rational&, int);

        friend Rational &operator^ (Rational&, int);

        friend int operator== (Rational, Rational);
        friend int operator== (Rational, int);
        friend int operator== (int,  Rational);

        friend int operator!= (Rational, Rational);
        friend int operator!= (Rational, int);
        friend int operator!= (int,  Rational);

        friend int operator< (Rational, Rational) ;
        friend int operator< (Rational, int);
        friend int operator< (int,  Rational);

        friend int operator<= (Rational, Rational);
        friend int operator<= (Rational, int);
        friend int operator<= (int,  Rational);

        friend int operator> (Rational, Rational);
        friend int operator> (Rational, int);
        friend int operator> (int,  Rational);

        friend int operator>= (Rational, Rational);
        friend int operator>= (Rational, int);
        friend int operator>= (int,  Rational);

        friend Rational abs(Rational);
};

#endif
