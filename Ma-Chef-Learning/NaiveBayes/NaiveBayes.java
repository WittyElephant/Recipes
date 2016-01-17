import java.util.*;
import java.io.*;
import java.lang.Math;

public class NaiveBayes{
  public static void main(String[] args) throws FileNotFoundException, IOException {
    validate(args);

    ArrayList<String> cuisines = findCuisines(args[0]);
    HashMap<String, Cuisine> structure = generateStructure(cuisines);
    trainNaiveBayes(structure, cuisines, args[0]);
    testNaiveBayes(structure, cuisines, args[1]);
  }

  public static HashMap<String, Cuisine> generateStructure(ArrayList<String> cuisines) {
    HashMap<String, Cuisine> structure = new HashMap<String, Cuisine>();
    for(int ii = 0; ii < cuisines.size(); ii++) {
      structure.put(cuisines.get(ii), new Cuisine());
    }

    return structure;
  }

  public static void trainNaiveBayes(HashMap<String, Cuisine> structure, ArrayList<String> cuisines, String filename) throws FileNotFoundException, IOException {
    BufferedReader reader = new BufferedReader(new FileReader(filename));
    String line;
    Cuisine thisCuisine;
    reader.readLine();
    while (true) {
      if((reader.readLine()).equals("]")) { // in most cases this is the initial '{'
        break;
      }

      reader.readLine(); // read the id, which we don't care about

      String cuisine = (reader.readLine()); // read the cuisine
      cuisine = cuisine.substring(16, cuisine.length()-2); // and parse it

      thisCuisine = structure.get(cuisine);
      thisCuisine.numRecipes++;

      reader.readLine(); // read the "ingredients" label, don't care

      while((line = reader.readLine()).equals("    ]") == false) { // read the ingredients
        String ingredient = line.substring(7, line.length() - 1);
        if(ingredient.charAt(ingredient.length() - 1) == '"') {
          ingredient = ingredient.substring(0, ingredient.length()-1);
        }

        if((thisCuisine.ingredientAttributes).containsKey(ingredient)) { // if we have encountered this ingredient in this cuisine before
          ((thisCuisine.ingredientAttributes).get(ingredient)).present++;
        } else { // if this is the first occurrence of this ingredient in this cuisine
          (thisCuisine.ingredientAttributes).put(ingredient, new Occurrence());
          (thisCuisine.ingredients).add(ingredient);
        }
      }
      reader.readLine(); // read the closing "}," or "}"
    }
    reader.close();

    populateOccurranceLikelihoods(structure, cuisines);
  }

  public static ArrayList<String> findCuisines(String filename) throws FileNotFoundException, IOException {
    BufferedReader reader = new BufferedReader(new FileReader(filename));
    String line;
    ArrayList<String> cuisines = new ArrayList<String>();
    while ((line = reader.readLine()) != null) {
      if(line.length() > 13 && line.substring(5,12).equals("cuisine")) {
        String cuisine = line.substring(16, line.length()-2);
        if(cuisines.contains(cuisine) == false) {
          cuisines.add(cuisine);
        }
      }
    }
    reader.close();
    return cuisines;
  }

  private static void populateOccurranceLikelihoods(HashMap<String, Cuisine> structure, ArrayList<String> cuisines) {
    int totalNumRecipes = 0;

    // Fill out the likelihoods for each ingredient found in each cuisine
    for(int cuisineIterator = 0; cuisineIterator < cuisines.size(); cuisineIterator++) {
      Cuisine thisCuisine = structure.get(cuisines.get(cuisineIterator));
      totalNumRecipes += thisCuisine.numRecipes;
      for(int ingredientIterator = 0; ingredientIterator < (thisCuisine.ingredients).size(); ingredientIterator++) {
        String thisIngredient = ((thisCuisine).ingredients).get(ingredientIterator);
        int numThisIngredientPresent = (((thisCuisine).ingredientAttributes).get(thisIngredient)).present;
        (((thisCuisine).ingredientAttributes).get(thisIngredient)).likelihood = (double) numThisIngredientPresent / thisCuisine.numRecipes;
      }
    }

    // Go back and fill out the likelihoods for each cuisine.
    for(int cuisineIterator = 0; cuisineIterator < cuisines.size(); cuisineIterator++) {
      Cuisine thisCuisine = structure.get(cuisines.get(cuisineIterator));
      thisCuisine.cuisineLikelihood = (double) thisCuisine.numRecipes / totalNumRecipes;
    }
  }

  public static void testNaiveBayes(HashMap<String, Cuisine> structure, ArrayList<String> cuisines, String testingFilename) throws FileNotFoundException, IOException {
    BufferedReader reader = new BufferedReader(new FileReader(testingFilename));
    reader.readLine(); //read the starting '['
    String id;
    ArrayList<String> ingredients = new ArrayList<String>();

    System.out.println("id,cuisine");
    // classify all recipes in the test file
    while((id = getNextRecipe(reader, ingredients)).equals("") == false) {
      double max = -1 * Double.MAX_VALUE; // initialize our current max to the smallest value
      String classification = "";

      // classify this recipe by performing Naive Bayes across all cuisines
      for(int cuisineIterator = 0; cuisineIterator < cuisines.size(); cuisineIterator++) {
        Cuisine thisCuisine = structure.get(cuisines.get(cuisineIterator));
        HashMap<String, Occurrence> thisCuisineAttributes = thisCuisine.ingredientAttributes;
        ArrayList<String> thisCuisineIngredients = thisCuisine.ingredients;
        double likelihood = Math.log10(thisCuisine.cuisineLikelihood);
        
        // perform Naive Bayes likelihood calculations on this cuisine
        for(int ingredientIterator = 0; ingredientIterator < thisCuisineIngredients.size(); ingredientIterator++) {
          // if this ingredient is found in both the test recipe and the cuisine
          if(ingredients.contains(thisCuisineIngredients.get(ingredientIterator))) {
            likelihood += Math.log10((thisCuisineAttributes.get(thisCuisineIngredients.get(ingredientIterator))).likelihood);
          } else { // if this ingredient is used in the cuisine but not this recipe
            likelihood += Math.log10(1 - (thisCuisineAttributes.get(thisCuisineIngredients.get(ingredientIterator))).likelihood);
          }
        }

        if(likelihood > max) {
          max = likelihood;
          classification = cuisines.get(cuisineIterator);
        }
      }
      
      System.out.println(id + "," + classification);
    }
    reader.close();
  }

  private static String getNextRecipe(BufferedReader testingFile, ArrayList<String> ingredients) throws FileNotFoundException, IOException {
    String line, id;
    ingredients.clear(); // clear list so we can collect a new batch of ingredients
    if((testingFile.readLine()).equals("]")) { // in most cases this is the initial '{'. Reaching ']' means end of file reached
        return "";
      }
    id = testingFile.readLine(); // read the id
    id = id.substring(10, id.length()-1);

    testingFile.readLine(); // read the "ingredients" label, don't care

    while((line = testingFile.readLine()).equals("    ]") == false) { // read the ingredients
      String ingredient = line.substring(7, line.length() - 1);
      if(ingredient.charAt(ingredient.length() - 1) == '"') {
        ingredient = ingredient.substring(0, ingredient.length()-1);
      }
      ingredients.add(ingredient);
    }
    testingFile.readLine(); // read the closing "}," or "}"
    return id;
  }

  private static void validate(String[] args) {
    if(args == null || args.length != 2) {
      System.err.println("Please specify training and testing files (in that order).");
      System.exit(0);
    }
  }
}

class Occurrence {
  int present;
  double likelihood;

  public Occurrence() {
    present = 1;
  }
}

class Cuisine {
  double cuisineLikelihood;
  HashMap<String, Occurrence> ingredientAttributes;
  int numRecipes;
  ArrayList<String> ingredients;

  public Cuisine() {
    ingredientAttributes = new HashMap<String, Occurrence>();
    numRecipes = 0;
    ingredients = new ArrayList<String>();
  }
}
