import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class MoveDetectionUtil {
  // Calculate the difference between two images
  static double calculateImageDifference(img.Image image1, img.Image image2) {
    // Ensure images are the same size
    if (image1.width != image2.width || image1.height != image2.height) {
      return 1.0; // Maximum difference
    }
    
    int totalPixels = image1.width * image1.height;
    int differentPixels = 0;
    
    // Compare each pixel
    for (int y = 0; y < image1.height; y++) {
      for (int x = 0; x < image1.width; x++) {
        int pixel1 = image1.getPixel(x, y);
        int pixel2 = image2.getPixel(x, y);
        
        // Calculate color difference
        int r1 = img.getRed(pixel1);
        int g1 = img.getGreen(pixel1);
        int b1 = img.getBlue(pixel1);
        
        int r2 = img.getRed(pixel2);
        int g2 = img.getGreen(pixel2);
        int b2 = img.getBlue(pixel2);
        
        // Calculate Euclidean distance between colors
        double distance = sqrt(pow(r1 - r2, 2) + pow(g1 - g2, 2) + pow(b1 - b2, 2));
        
        // If the distance is above a threshold, count as different
        if (distance > 30) { // Threshold can be adjusted
          differentPixels++;
        }
      }
    }
    
    // Return the percentage of different pixels
    return differentPixels / totalPixels;
  }
  
  // Detect regions of change between two images
  static List<Rect> detectChangedRegions(img.Image image1, img.Image image2, {double threshold = 30}) {
    List<Rect> changedRegions = [];
    
    // Create a difference map
    img.Image diffMap = img.Image(width: image1.width, height: image1.height);
    
    // Mark pixels that have changed significantly
    for (int y = 0; y < image1.height; y++) {
      for (int x = 0; x < image1.width; x++) {
        int pixel1 = image1.getPixel(x, y);
        int pixel2 = image2.getPixel(x, y);
        
        int r1 = img.getRed(pixel1);
        int g1 = img.getGreen(pixel1);
        int b1 = img.getBlue(pixel1);
        
        int r2 = img.getRed(pixel2);
        int g2 = img.getGreen(pixel2);
        int b2 = img.getBlue(pixel2);
        
        double distance = sqrt(pow(r1 - r2, 2) + pow(g1 - g2, 2) + pow(b1 - b2, 2));
        
        if (distance > threshold) {
          diffMap.setPixel(x, y, img.getColor(255, 255, 255)); // White for changed
        } else {
          diffMap.setPixel(x, y, img.getColor(0, 0, 0)); // Black for unchanged
        }
      }
    }
    
    // TODO: Implement connected component analysis to identify distinct regions
    // For now, we'll use a simple approach to identify potential move regions
    
    // A chess move typically involves two regions of change:
    // 1. The source square (where a piece was)
    // 2. The destination square (where the piece moved to)
    
    // For demonstration, we'll return a placeholder region
    changedRegions.add(Rect.fromLTWH(0, 0, 100, 100));
    
    return changedRegions;
  }
  
  // Determine if the changes represent a chess move
  static bool isChessMove(List<Rect> changedRegions, double differencePercentage) {
    // A chess move typically has these characteristics:
    // 1. Two main regions of change (source and destination squares)
    // 2. The regions are roughly square-shaped
    // 3. The regions are of similar size
    // 4. The total area of change is relatively small compared to the whole board
    
    // For now, use a simple heuristic
    if (changedRegions.length >= 1 && changedRegions.length <= 4 && 
        differencePercentage > 0.01 && differencePercentage < 0.1) {
      return true;
    }
    
    return false;
  }
}