import cv2
import numpy as np

# Read the image
image = cv2.imread('map.jpg')

image = cv2.resize(image, (1280, 800))

# Convert to grayscale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# Apply thresholding to get the white areas
_, thresh = cv2.threshold(gray, 240, 255, cv2.THRESH_BINARY)

# Find contours using cv2.RETR_CCOMP to get all the contours
contours, hierarchy = cv2.findContours(thresh, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)

# Initialize a list to hold the bounding boxes
bounding_boxes = []
some_minimum_area_threshold = 100

# Initialize a variable to keep count of the boxes
box_count = 0

# Loop over the contours
# Loop over the contours and hierarchy together
for idx, (contour, hier) in enumerate(zip(contours, hierarchy[0])):
    # Skip small contours to avoid noise
    if cv2.contourArea(contour) > some_minimum_area_threshold:
        # Draw the contour on the original image (optional)
        cv2.drawContours(image, [contour], -1, (0, 255, 0), 2)

        # If contour has no parent, it's an outer contour
        if hier[3] == -1:
            # Get the bounding rectangle for the outer contour
            x, y, w, h = cv2.boundingRect(contour)
            bounding_boxes.append((x, y, w, h))
            # Optionally draw bounding box for outer contour
            cv2.rectangle(image, (x, y), (x + w, y + h), (255, 0, 0), 1)
            # Draw the box number
            cv2.putText(image, str(box_count), (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)
            box_count += 1

        # Check if there is a child contour
        if hier[2] != -1:
            # Process child contours
            child_idx = hier[2]
            while child_idx != -1:
                child_contour = contours[child_idx]
                # Get the bounding rectangle for each child contour
                x, y, w, h = cv2.boundingRect(child_contour)
                if cv2.contourArea(child_contour) > some_minimum_area_threshold:
                    bounding_boxes.append((x, y, w, h))
                    # Optionally draw bounding box for each child
                    cv2.rectangle(image, (x, y), (x + w, y + h), (255, 0, 0), 1)
                    # Draw the box number
                    cv2.putText(image, str(box_count), (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)
                    box_count += 1
                # Move to the next child contour in hierarchy
                child_idx = hierarchy[0][child_idx][0]

# Show the image with all the drawn boundaries and numbers
cv2.imshow('Image with All White Spaces', image)
cv2.waitKey(0)
cv2.destroyAllWindows()

# Output the bounding box coordinates
for i, bbox in enumerate(bounding_boxes):
    x, y, w, h = bbox
    print(f"Bounding box {i}: x={x}, y={y}, width={w}, height={h}")




