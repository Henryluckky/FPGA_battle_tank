from PIL import Image

def png_to_jpg_with_white_background(input_path, output_path):
    # Open the PNG image
    png_image = Image.open(input_path)

    # Convert the image to RGBA if it's not
    if png_image.mode != 'RGBA':
        png_image = png_image.convert('RGBA')

    # Prepare a white background
    white_background = Image.new('RGB', png_image.size, (255, 255, 255))

    # Paste the PNG image onto the white background
    white_background.paste(png_image, mask=png_image.split()[3])  # Use the alpha channel as the mask

    # Save the result as JPG
    white_background.save(output_path, 'JPEG', quality=95)

# Example usage
png_to_jpg_with_white_background('target2.png', 'target2.jpg')
