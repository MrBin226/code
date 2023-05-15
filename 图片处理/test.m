clc;
clear;
a = imread('lena.jpg');
n_mat = fast_design_text_dct_non_zero_coef_attack(a);