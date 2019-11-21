# CS6620: Advanced Computer Organization and Architecture with Lab
# Lab Assignment-6 

## Code-Conversion (Submission Deadline:27/11/19)

### Part 1
Write an assembly program for searching a given integer number in an
array of integer numbers. Assume that the numbers in the array are not in
sorted order. The program must ask the user to enter the number of
elements of the array and accept each element of the array through
keyboard (for this, you need to use software interrupts). Also, the user must
enter the element to be searched through keyboard. You must pass the
array and the searching element as parameters to a subroutine, **SEARCH**.
The program outputs the position of the given element, if it is present in the
array, otherwise, it outputs **-1**.

For example:

|         |           |             |
|:-------:|:---------:|:-----------:|
|  Input: |   A |43,25,100,10,9|
|  Search Element:|   N |      10     |
|  Output:|    |      4    |
|  Search Element:|   N |      26     |
|  Output:|    |      -1    |


### Part 2
In the above problem, as the elements of the array are not in sorted order,
we have to search all the elements to find whether a given element is
present or not. Now, assume that the elements of the array are in sorted
order. Write an assembly language program that can efficiently search a
given element in the sorted array of elements. (Note that here we define the
efficiency in terms of the number of searches. )

#### Part 3
Fibonacci number sequence is defined as 1, 1, 2, 3, 5, 8, 13, 21, ... A number
in the Fibonacci sequence is the sum of the immediate two previous
numbers, i.e., Fn = F{n-1}+F{n-2}, n>2. Note that F1 = F2 = 1. Write an assembly
language program that accepts an integer number, N, through keyboard and
computes the Nth Fibonacci number in recursive way.

For example:

|         |           |             |
|:-------:|:---------:|:-----------:|
|  Input: |   N       |   10        |
|  Output:|   F_N     |   55        |



**Add necessary comments to your program for easy readability.**
**Add Directed Screenshots for the respective outputs.**

***no starter code will be provided***
