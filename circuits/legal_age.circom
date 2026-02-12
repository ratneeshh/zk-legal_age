pragma circom 2.2.3;

include "circomlib/circuits/comparators.circom";

template LegalAge() {

    signal input bDate;
    signal input bMonth;
    signal input bYear;

    signal input cDate;
    signal input cMonth;
    signal input cYear;

    signal output isAbove18;

    signal diffYear;
    diffYear <== cYear - bYear;

    component monthLess = LessThan(8);
    monthLess.in[0] <== cMonth;
    monthLess.in[1] <== bMonth;

    component monthEqual = IsEqual();
    monthEqual.in[0] <== cMonth;
    monthEqual.in[1] <== bMonth;

    component dateLess = LessThan(8);
    dateLess.in[0] <== cDate;
    dateLess.in[1] <== bDate;

    signal shouldReduce;
    shouldReduce <== monthLess.out + (monthEqual.out * dateLess.out);

    signal age;
    age <== diffYear - shouldReduce;

    component lt18 = LessThan(8);
    lt18.in[0] <== age;
    lt18.in[1] <== 18;

    signal isMinor;
    isMinor <== lt18.out;

    isAbove18 <== 1 - isMinor;

    isAbove18 === 1;
}

component main = LegalAge();
