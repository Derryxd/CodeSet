# -*- coding: utf-8 -*-
"""
Created on Wed Jan 24 21:29:12 2018

@author: ldz
"""

# =============================================================================
'''common sorting algorithm'''
# =============================================================================
'''time complexity: O(n*n)'''
def insertion_sort(sort_list):
    iter_len = len(sort_list)
    if iter_len < 2:
        return sort_list
    for i in range(1,iter_len):
        key = sort_list[i]
        j = i - 1            #将i+1的key插入前i个数中
        while j >= 0 and sort_list[j] > key:
            sort_list[j+1] = sort_list[j]
            j -= 1           
        sort_list[j+1] = key #j+1为key所插位置
    return sort_list

def bubble_sort(sort_list):
    iter_len = len(sort_list)
    if iter_len < 2:
        return sort_list
    for i in range(iter_len):
        for j in range(iter_len-i-1):
            if sort_list[j] > sort_list[j+1]:
                sort_list[j], sort_list[i] = \
                sort_list[i], sort_list[j]
    return sort_list
                
def selection_sort(sort_list):
    iter_len = len(sort_list)
    if iter_len < 2:
        return sort_list
    for i in range(iter_len-1):
        smallest = sort_list[i]
        location = i
        for j in range(i,iter_len):
            if sort_list[j] < smallest:
                location = j
        if i != location:
            sort_list[i],sort_list[j] = \
            sort_list[j],sort_list[i]
    return sort_list
            
'''time complexity: O(n*log(n))'''     
class merge_sort(object):
    def _merge(self, alist, p, q, r):
        left = alist[p:q+1]
        right = alist[q+1:r+1]
        for i in range(p, r+1):
            if len(left) > 0 and len(right) > 0:
                if left[0] <= right[0]:
                    alist[i] = left.pop(0)
                else:
                    alist[i] = right.pop(0)
            elif len(right) == 0:
                alist[i] = left.pop(0)
            elif len(left) == 0:
                alist[i] = right.pop(0)
 
    def _merge_sort(self, alist, p, r): #递归
        if p<r:   #len=1直接返回sort_list
            q = int((p+r)/2)
            self._merge_sort(alist, p, q)
            self._merge_sort(alist, q+1, r)
            self._merge(alist, p, q, r)
 
    def __call__(self, sort_list):
        self._merge_sort(sort_list, 0, len(sort_list)-1)
        return sort_list

class heap_sort(object):
    def _left(self, i):
        return 2*i+1
    def _right(self, i):
        return 2*i+2
    def _parent(self, i):
        if i%2==1:
            return int(i/2)
        else:
            return i/2-1
     
    def _max_heapify(self, alist, i, heap_size=None):
        length = len(alist)
         
        if heap_size is None:
            heap_size = length
 
        l = self._left(i)
        r = self._right(i)
 
        if l < heap_size and alist[l] > alist[i]:
            largest = l
        else:
            largest = i
        if r < heap_size and alist[r] > alist[largest]:
            largest = r
 
        if largest!=i:
            alist[i], alist[largest] = alist[largest], alist[i]
            self._max_heapify(alist, largest, heap_size)
 
    def _build_max_heap(self, alist):
        roop_end = int(len(alist)/2)
        for i in range(0, roop_end)[::-1]:
            self._max_heapify(alist, i)
 
    def __call__(self, sort_list):
        self._build_max_heap(sort_list)
        heap_size = len(sort_list)
        for i in range(1, len(sort_list))[::-1]:
            sort_list[0], sort_list[i] = sort_list[i], sort_list[0]
            heap_size -= 1
            self._max_heapify(sort_list, 0, heap_size)
 
        return sort_list
    
class quick_sort(object):
    def _partition(self, alist, p, r):
        i = p-1
        x = alist[r]
        for j in range(p, r):
            if alist[j] <= x:
                i += 1
                alist[i], alist[j] = alist[j], alist[i]
        alist[i+1], alist[r] = alist[r], alist[i+1]
        return i+1
 
    def _quicksort(self, alist, p, r):
        if p < r:
            q = self._partition(alist, p, r)
            self._quicksort(alist, p, q-1)
            self._quicksort(alist, q+1, r)
 
    def __call__(self, sort_list):
        self._quicksort(sort_list, 0, len(sort_list)-1)
        return sort_list



















