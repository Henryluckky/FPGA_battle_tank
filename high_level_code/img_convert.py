from PIL import Image

# Load the PNG image
png_image = Image.open('target.png')

# Convert the image to RGB mode (JPG does not support transparency)
rgb_image = png_image.convert('RGB')

# Save the image in JPG format
rgb_image.save('target.jpg', quality=95)