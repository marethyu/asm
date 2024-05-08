#include <stdio.h>
#include <stdlib.h>

void sort(int* arr, int n)
{
    for (int i = 0; i < n; ++i)
    {
        int minElement = arr[i];
        int minIndex = i;

        for (int j = i + 1; j < n; ++j)
        {
            if (minElement > arr[j])
            {
                minElement = arr[j];
                minIndex = j;
            }
        }

        int tmp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = tmp;
    }
}

int main()
{
    int n;

    scanf("%d", &n);

    int* arr = (int*) malloc(sizeof(int) * n);

    for (int i = 0; i < n; ++i)
    {
        scanf("%d", arr + i);
    }

    sort(arr, n);

    printf("sorted array:\n");

    for (int i = 0; i < n; ++i)
    {
        printf("%d\n", arr[i]);
    }

    free(arr);

    return 0;
}
