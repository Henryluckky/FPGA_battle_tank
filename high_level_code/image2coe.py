from PIL import Image
import numpy as np


def image_to_coe(image_path, output_path, width, height):
    # Open the image
    image = Image.open(image_path)
    # Resize the image
    image = image.resize((width, height))

    # Convert the image to a numpy array
    image_data = np.array(image)
    # image_data=image_data[3:4,:,:]
    print(image_data.shape)

    # Check if the image is not already in 'RGB' mode
    if image_data.shape[2] != 3:
        raise ValueError("Image must be in RGB format")

    # Prepare the .coe file header
    header = "; Sample .COE file\n"
    header += "memory_initialization_radix=16;\n"
    header += "memory_initialization_vector=\n"

    # Convert the pixel values to 12-bit hexadecimal and prepare the data string
    data_str = ""
    for row in image_data:
        for pixel in row:
            # Scale each RGB value to 4 bits and combine them to get a 12-bit value
            r, g, b = [format(val >> 4, '1X') for val in pixel]  # Scale to 4 bits and format as hexadecimal
            rgb_12bit = r + g + b
            data_str += rgb_12bit + ",\n"

    # Remove the last comma and newline
    data_str = data_str.rstrip(",\n")

    # Write to the .coe file
    with open(output_path, 'w') as file:
        file.write(header + data_str + ";")


# Usage example
image_to_coe('loss.jpg', 'loss.coe', 512, 384)
