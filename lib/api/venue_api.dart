import 'data/venue.dart';

Future<List<String>> getImages() async {
  final List<String> mocked = [
    'https://images.unsplash.com/photo-1528114039593-4366cc08227d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8aXRhbHl8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
    'https://images.unsplash.com/photo-1571492811573-16dccc6f21f8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxyZXN0YXVyYW50JTIwb3V0c2lkZXxlbnwwfHx8fDE3MTk1MDk4NTB8MA&ixlib=rb-4.0.3&q=80&w=1080',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyfHxyZXN0YXVyYW50fGVufDB8fHx8MTcxOTQ4NjQ0M3ww&ixlib=rb-4.0.3&q=80&w=1080',
    'https://images.unsplash.com/photo-1551024506-0bccd828d307?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyM3x8ZGVzc2VydCUyMGZpbmV8ZW58MHx8fHwxNzE5NTA5ODIyfDA&ixlib=rb-4.0.3&q=80&w=1080',
    'https://images.unsplash.com/photo-1616671285410-2a676a9a433d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxmaW5lJTIwZGluaW5nfGVufDB8fHx8MTcxOTUwOTc4OHww&ixlib=rb-4.0.3&q=80&w=1080',
    'https://images.unsplash.com/photo-1623073284788-0d846f75e329?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHxmaW5lJTIwZGluaW5nfGVufDB8fHx8MTcxOTUwOTc4OHww&ixlib=rb-4.0.3&q=80&w=1080',
    'https://images.unsplash.com/photo-1592861956120-e524fc739696?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxMXx8cmVzdGF1cmFudHxlbnwwfHx8fDE3MTk0ODY0NDN8MA&ixlib=rb-4.0.3&q=80&w=1080',
  ];
  return mocked;
}

Future<List<Venue>> getAllVenues() async {
  final List<Venue> allVenues = [
    Venue(
      id: 1,
      name: 'Mele Melinda',
      location: 'Poreč',
      workingHours: '8:00 AM - 10:00 PM',
      rating: 5,
      type: VenueType.italian,
      description: 'A lovely place to eat.',
    ),
    Venue(
      id: 2,
      name: 'Pizzeria Da Giacomo',
      location: 'Rovinj',
      workingHours: '8:00 AM - 10:00 PM',
      rating: 2,
      type: VenueType.pizza,
      description: 'A lovely place to eat.',
    ),
    Venue(
      id: 3,
      name: 'Gelateria La Carraia',
      location: 'Pula',
      workingHours: '8:00 AM - 10:00 PM',
      rating: 3.5,
      type: VenueType.ice_cream,
      description: 'A lovely place to eat.',
    ),
    Venue(
      id: 4,
      name: 'Gelateria Dei Neri',
      location: 'Rovinj',
      workingHours: '8:00 AM - 10:00 PM',
      rating: 3,
      type: VenueType.ice_cream,
      description: 'A lovely place to eat.',
    ),
    Venue(
      id: 5,
      name: 'Chang',
      location: 'Kopar',
      workingHours: '8:00 AM - 10:00 PM',
      rating: 5,
      type: VenueType.chinese,
      description: 'A lovely place to eat.',
    ),
    Venue(
      id: 6,
      name: 'Umi',
      location: 'Poreč',
      workingHours: '8:00 AM - 10:00 PM',
      rating: 4.5,
      type: VenueType.asian,
      description: 'A lovely place to eat.',
    ),
    Venue(
      id: 7,
      name: 'Tsuki',
      location: 'Rovinj',
      workingHours: '8:00 AM - 10:00 PM',
      rating: 3,
      type: VenueType.japanese,
      description: 'A lovely place to eat.',
    ),
    Venue(
      id: 8,
      name: 'Pizzeria Da Michele',
      location: 'Pula',
      workingHours: '8:00 AM - 10:00 PM',
      rating: 4,
      type: VenueType.pizza,
      description: 'A lovely place to eat.',
    ),
  ];
  return allVenues;
}

Future<List<Venue>> getNearbyVenues() async {
  List<Venue> allVenues = await getAllVenues();
  List<Venue> nearbyVenues = allVenues
      .where((venue) => venue.location == 'Poreč' || venue.location == 'Rovinj')
      .toList();
  nearbyVenues.sort((a, b) => a.location.compareTo(b.location));
  return nearbyVenues;
}

Future<List<Venue>> getTrendingVenues() async {
  List<Venue> allVenues = await getAllVenues();
  List<Venue> trendingVenues =
      allVenues.where((venue) => venue.rating >= 4).toList();
  trendingVenues.sort((a, b) => b.rating.compareTo(a.rating));
  return trendingVenues;
}

Future<List<Venue>> getNewVenues() async {
  List<Venue> allVenues = await getAllVenues();
  allVenues.sort((a, b) => b.id.compareTo(a.id));
  List<Venue> newVenues = allVenues.take(8).toList();
  return newVenues;
}

Future<List<Venue>> getSuggestedVenues() async {
  List<Venue> allVenues = await getAllVenues();
  allVenues.sort((a, b) => a.name.compareTo(b.name));
  return allVenues.toList();
}
