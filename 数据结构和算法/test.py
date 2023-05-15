from typing import List


def search(nums: List[int], target: int) -> int:
    if len(nums) == 1:
        return 0 if nums[0] == target else -1
    left = 0
    right = len(nums) - 1
    while left < right:
        mid = left + ((right - left) >> 1)
        if nums[mid] == target:
            return mid
        elif target < nums[mid] < nums[right] or nums[left] <= target < nums[mid]:
            right = mid
        elif target < nums[left] < nums[mid]:
            left = mid + 1
        elif nums[mid] < nums[right] < target:
            right = mid
        elif nums[mid] < target <= nums[right] or target > nums[mid] > nums[left]:
            left = mid + 1
    return right if nums[right] == target else -1

print(search([3,5,1], 3))