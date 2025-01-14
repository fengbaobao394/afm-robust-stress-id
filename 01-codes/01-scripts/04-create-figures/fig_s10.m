% =========================================================================
% Name   : fig_s10.m
% Author : Brandon Sloan
% Date   : 2/28/23
%
% DESCRIPTION
% This script creates Figure S10 from Sloan and Feng (2023).
%
% =========================================================================

clc
clear
close all

% Load data
load pmoc_default_opts
load final_ec_site_properties.mat
load ec-site-coverage.mat
spath = '.\03-outputs\03-figures\';

SiteProp = outerjoin(SiteProp,SiteCoverage,'Type','Left','LeftKeys','Site_ID','RightKeys','SiteID');
perc_rem = 100 - cell2mat(SiteProp.perc_left);

% Random uncertainty
close all
ar = 4/3;
wd = 3*2.54;
ht = wd/ar;
fr = 14/12;
fs = 8;
ft = 'CMU Sans Serif';
h = histogram(perc_rem,0:5:100,'FaceColor','none','EdgeColor','k');
hold on
plotLine([],[],'Data Removed via Filtering (%)',...
    'No. of Sites','','-',2,...
    0.5,[70,100],[],fs/fr,ft,'b',[1,1,wd,ht]);
gax = gca;
gax.LabelFontSizeMultiplier = fr;
gax.XTick = [70,85,100];
%gax.YTick = [0,0.1];
print([spath,'fig-s10'],'-dpng','-r1200')
