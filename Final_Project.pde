/*
Dipo Olaleye
 Final Processing project
 TODO: Add brief descripton of final project here
 */
int gameState = 0;
float playerX;
float playerY;
float playerSpeed = 4;
int starCount = 80;
float[] starX = new float[starCount];
float[] starY = new float[starCount];
float[] starSpeed = new float[starCount];
int maxBullets = 100;
float[] bulletX = new float[maxBullets];
float[] bulletY = new float[maxBullets];
boolean[] bulletActive = new boolean[maxBullets];
float bulletSpeed = 8;
int maxEnemies = 10;
float[] enemyX = new float[maxEnemies];
float[] enemyY = new float[maxEnemies];
boolean[] enemyActive = new boolean[maxEnemies];
float enemySpeed = 3;
int enemySpawnTimer = 0;
int enemySpawnDelay = 90;
int score = 0;
int playerHealth = 3;


void setup() {
  size(800, 600);

  playerX = width / 2;
  playerY = height / 2;

  initializeStars();
}


void draw() {
  background(8, 12, 30);

  drawStars();

  if (gameState == 0) {
    drawMenu();
  } 
  
  else if (gameState == 1) {
    movePlayer();
    keepPlayerOnScreen();
    drawPlayer();

    updateBullets();

    handleEnemySpawning();
    updateEnemies();

    checkBulletCollisions();
    checkPlayerCollisions();

    
    if (playerHealth <= 0) {
      gameState = 2;
    }

    
    if (gameState == 1) {
      drawScore();
      drawHealth();
    }
  }


  if (gameState == 2) {
    drawGameOver();
  }
}




void drawMenu() {
  textAlign(CENTER);

  fill(255);
  textSize(46);
  text("SPACE SURVIVOR", width / 2, 150);

  fill(120, 200, 255);
  textSize(18);
  text("SURVIVE. ADAPT. CONQUER.", width / 2, 200);

  if (isMouseOverButton()) {
    fill(100, 220, 255);
  } else {
    fill(60, 190, 255);
  }

  stroke(180, 230, 255);
  strokeWeight(2);
  rect(width / 2 - 100, 280, 200, 60, 12);
  noStroke();

  fill(10, 20, 40);
  textSize(24);
  text("START GAME", width / 2, 318);

  fill(200);
  textSize(15);
  text("MOVE: W  A  S  D", width / 2, 390);
  text("Prepare for incoming enemy waves", width / 2, 425);
}


boolean isMouseOverButton() {
  if (mouseX >= 300 && mouseX <= 500 &&
      mouseY >= 280 && mouseY <= 340) {
    return true;
  }

  return false;
}

boolean isMouseOverPlayAgainButton() {
  if (mouseX >= 300 && mouseX <= 500 &&
      mouseY >= 445 && mouseY <= 500) {
    return true;
  }

  return false;
}

void mousePressed() {
  if (gameState == 0 && isMouseOverButton()) {
    gameState = 1;
  }

  else if (gameState == 2 && isMouseOverPlayAgainButton()) {
    resetGame();
  }
}




void shootBullet() {
  for (int i = 0; i < maxBullets; i++) {
    if (bulletActive[i] == false) {
      bulletX[i] = playerX + 20;
      bulletY[i] = playerY;

      bulletActive[i] = true;
      break;
    }
  }
}




void movePlayer() {
  if (keyPressed) {
    if (key == 'w' || key == 'W') {
      playerY -= playerSpeed;
    }

    if (key == 's' || key == 'S') {
      playerY += playerSpeed;
    }

    if (key == 'a' || key == 'A') {
      playerX -= playerSpeed;
    }

    if (key == 'd' || key == 'D') {
      playerX += playerSpeed;
    }
  }
}


void keepPlayerOnScreen() {
  if (playerX > width - 25) {
    playerX = width - 25;
  }

  if (playerX < 25) {
    playerX = 25;
  }

  if (playerY > height - 25) {
    playerY = height - 25;
  }

  if (playerY < 25) {
    playerY = 25;
  }
}


void drawPlayer() {
  fill(60, 190, 255);
  noStroke();

  triangle(
    playerX + 20, playerY,
    playerX - 15, playerY - 15,
    playerX - 15, playerY + 15
  );

  fill(220, 250, 255);
  ellipse(playerX + 3, playerY, 8, 8);
}




void initializeStars() {
  for (int i = 0; i < starCount; i++) {
    starX[i] = random(width);
    starY[i] = random(height);
    starSpeed[i] = random(1, 4);
  }
}


void drawStars() {
  noStroke();

  for (int i = 0; i < starCount; i++) {
    starY[i] += starSpeed[i];

    if (starY[i] > height) {
      starY[i] = 0;
      starX[i] = random(width);
    }

    fill(255);
    ellipse(starX[i], starY[i], 3, 3);
  }
}



void keyPressed() {
  if (gameState == 1 && key == ' ') {
    shootBullet();
  }
}



void updateBullets() {
  for (int i = 0; i < maxBullets; i++) {
    if (bulletActive[i]) {
      bulletX[i] += bulletSpeed;

      if (bulletX[i] > width) {
        bulletActive[i] = false;
      } else {
        noStroke();
        fill(60, 220, 255);
        ellipse(bulletX[i], bulletY[i], 14, 5);
      }
    }
  }
}




void spawnEnemy() {
  for (int i = 0; i < maxEnemies; i++) {
    if (enemyActive[i] == false) {
      enemyX[i] = width + 20;
      enemyY[i] = random(30, height - 30);
      enemyActive[i] = true;
      break;
    }
  }
}


void updateEnemies() {
  for (int i = 0; i < maxEnemies; i++) {
    if (enemyActive[i]) {
      enemyX[i] -= enemySpeed;

      fill(255, 80, 60);
      noStroke();
      ellipse(enemyX[i], enemyY[i], 30, 30);

      if (enemyX[i] < -30) {
        enemyActive[i] = false;
      }
    }
  }
}


void handleEnemySpawning() {
  enemySpawnTimer++;

  if (enemySpawnTimer >= enemySpawnDelay) {
    spawnEnemy();
    enemySpawnTimer = 0;
  }
}




void checkBulletCollisions() {
  for (int i = 0; i < maxBullets; i++) {
    if (bulletActive[i]) {

      for (int j = 0; j < maxEnemies; j++) {
        if (enemyActive[j]) {

          float distance = dist(
            bulletX[i], bulletY[i],
            enemyX[j], enemyY[j]
          );

          if (distance < 22) {
            bulletActive[i] = false;
            enemyActive[j] = false;

            score += 10;

            break;
          }
        }
      }
    }
  }
}




void checkPlayerCollisions() {
  for (int j = 0; j < maxEnemies; j++) {
    if (enemyActive[j]) {

      float distance = dist(
        playerX, playerY,
        enemyX[j], enemyY[j]
      );

      if (distance < 30) {
        playerHealth -= 1;
        enemyActive[j] = false;

        break;
      }
    }
  }
}




void drawScore() {
  fill(255);
  textSize(20);
  textAlign(LEFT);

  text("SCORE: " + score, 20, 30);
}




void drawHealth() {
  fill(255);
  textSize(20);
  textAlign(RIGHT);

  text("HEALTH: " + playerHealth, width - 20, 30);
}




void drawGameOver() {
  textAlign(CENTER);

  
  fill(255, 80, 80);
  textSize(48);
  text("GAME OVER", width / 2, height / 2);

  
  fill(255);
  textSize(24);
  text("FINAL SCORE: " + score, width / 2, height / 2 + 70);

  
  fill(180);
  textSize(16);
  text("YOUR MISSION HAS ENDED", width / 2, height / 2 + 110);

  
  fill(60, 190, 255);
  stroke(180, 230, 255);
  strokeWeight(2);
  rect(width / 2 - 100, height / 2 + 145, 200, 55, 12);

  
  noStroke();
  fill(255);
  textSize(22);
  text("PLAY AGAIN", width / 2, height / 2 + 180);
}

void resetGame() {
  playerX = width / 2;
  playerY = height / 2;
  playerHealth = 3;
  score = 0;
  enemySpawnTimer = 0;
  
  for (int i = 0; i < maxBullets; i++) {
  bulletActive[i] = false;
  }
  
  for (int j = 0; j < maxEnemies; j++) {
  enemyActive[j] = false;
  gameState = 1;
  }
}
