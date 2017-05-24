function [ mask ] = findDinamicObjects( gt )
%FINDDINAMICOBJECTS Summary of this function goes here
%   Detailed explanation goes here

    mask = logical(((gt==8) + (gt==10) + (gt==11))>0);
end

