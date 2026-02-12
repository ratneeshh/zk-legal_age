pragma circom 2.2.3;

include "circomlib/circuits/comparators.circom";


template CalculateAge() {

    // Inputs
    signal input bDate;
    signal input bMonth;
    signal input bYear;

    signal input cDate;
    signal input cMonth;
    signal input cYear;

    signal output age;

    // Year difference
    signal diffYear;
    diffYear <== cYear - bYear;

    // Check if current month < birth month
    component monthLess = LessThan(8);
    monthLess.in[0] <== cMonth;
    monthLess.in[1] <== bMonth;

    // Check if months are equal
    component monthEqual = IsEqual();
    monthEqual.in[0] <== cMonth;
    monthEqual.in[1] <== bMonth;

    // Check if current date < birth date
    component dateLess = LessThan(8);
    dateLess.in[0] <== cDate;
    dateLess.in[1] <== bDate;

    // If month < OR (month == AND date <)
    signal shouldReduce;
    shouldReduce <== monthLess.out + (monthEqual.out * dateLess.out);

    // Final age
    age <== diffYear - shouldReduce;
}

component main = CalculateAge();
