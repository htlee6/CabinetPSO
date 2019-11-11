function dist = distance(vec1, vec2)
    dist = sqrt( sum((vec1-vec2).^2) );
end