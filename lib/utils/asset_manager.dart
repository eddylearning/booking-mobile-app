class AssetsManager {
  // Base Paths
  static String imagesPath = "assets/images";
  
  // Organized Folders
  static String uiPath = "$imagesPath/ui"; // For icons (error, success, etc)
  static String profileImagesPath = "$imagesPath/profile"; 
  static String categoriesImagesPath = "$imagesPath/categories";
  static String bannersImagesPath = "$imagesPath/banners";
  static String dashboardImagesPath = "$imagesPath/dashboard";
  static String productsImagesPath = "$imagesPath/products"; // Placeholders

  // --- UI / States (General) ---
  static String forgotPassword = "$uiPath/forgot_password.jpg";
  static String mapRounded = "$uiPath/rounded_map.png";
  static String warning = "$uiPath/warning.png";
  static String error = "$uiPath/error.png";
  static String addressMap = "$uiPath/address_map.png";
  static String emptySearch = "$uiPath/empty_search.png";
  static String successful = "$uiPath/successful.png";

  // --- Profile Icons ---
  static String address = "$profileImagesPath/address.png";
  static String login = "$profileImagesPath/login.png";
  static String logout = "$profileImagesPath/logout.png";
  static String privacy = "$profileImagesPath/privacy.png";
  static String recent = "$profileImagesPath/recent.png";
  static String theme = "$profileImagesPath/theme.png";
  
  // --- Farm Specific Categories (Replacing Mobiles/Fashion) ---
  static String vegetables = "$categoriesImagesPath/vegetables.png";
  static String fruits = "$categoriesImagesPath/fruits.png";
  static String dairy = "$categoriesImagesPath/dairy.png";
  static String roots = "$categoriesImagesPath/roots.png";
  static String cereals = "$categoriesImagesPath/cereals.png";
  static String herbs = "$categoriesImagesPath/herbs.png";

  // --- Banners ---
  static String banner1 = "$bannersImagesPath/banner1.jpg";
  static String banner2 = "$bannersImagesPath/banner2.jpg";
  static String banner3 = "$bannersImagesPath/banner3.jpg";
  static String banner4 = "$bannersImagesPath/banner4.jpg";

  // --- Dashboard / Admin ---
  static String order = "$dashboardImagesPath/order.png";
  static String analytics = "$dashboardImagesPath/analytics.png";
  static String products = "$dashboardImagesPath/products.png"; // For managing products

  // --- Product Placeholders ---
  static String productPlaceholder = "$productsImagesPath/placeholder.png";
}