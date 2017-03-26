function [] = calibration_mcmc(varargin)
%This function initiates the genetic algorithm to solve for
%the parameters of the model.  Initial parameter guesses can be set here,
%as well as optional settings for the genetic algorithm.

    % set defaults for optional inputs
    optargs = {0};

    % overwrite defaults with user input
    numvarargs = size(varargin, 2);
    optargs(1:numvarargs) = varargin;

    % memorable variable names
    rst = optargs{1}; % parameter restriction?

    % what type of parameter restriction?
    rst_type = 'non';
    if rst == 1
        rst_type = query(['Which type of parameter restriction?' char(10) 'nln (no learning)' char(10) 'nnt (no network effect)?'],{'nln','nnt'});
    elseif rst == 2
        rst_type = 'nnt' %set no network
    elseif rst == 3
        rst_type = 'nln' %set no learning
    end

    
    mcmc_new

    % Parallel setup
%     clc

    
    % Start timer
    tic;
    
    % Put numbers in long format for printing
    format long;
    