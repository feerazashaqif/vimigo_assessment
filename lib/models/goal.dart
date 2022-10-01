class Goal {
   int level;
   String message;

  Goal(this.level, this.message);

  static List<Goal> goals = [
    Goal(1, 'Sign up & log in'),
    Goal(2, 'Reach 80 KPI points'),
    Goal(3, 'Reach 150 KPI points'),
    Goal(4, 'Reach 220 KPI points'),
    Goal(5, 'Reach 500 KPI points'),
  ];
}
