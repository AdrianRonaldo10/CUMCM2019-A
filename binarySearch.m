function ind = binarySearch(A, num)

left = 1;
right = length(A);
while left < right
    mid = floor((left + right) / 2);
    if A(mid) < num
        left = mid + 1;
    else
        right = mid;
    end
end
ind = left;