const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

const serviceAccount = require("./firebase-key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function upload(filePath, subject) {

  const absolutePath = path.resolve(filePath);

  const raw = JSON.parse(fs.readFileSync(absolutePath, "utf8"));

  const questions = raw.questions || raw;

  if (!Array.isArray(questions)) {
    console.log(`Invalid JSON format in ${filePath}`);
    return;
  }

  for (const q of questions) {

    await db.collection("Questions").add({
      question: q.question,
      options: q.options,
      answer: q.answer,
      explanation: q.explanation,
      exam: "rbi_assistant",
      stage: "prelims",
      subject: subject
    });

  }

  console.log(`${questions.length} questions uploaded for ${subject}`);

}

async function main() {

  try {

    await upload("./question_bank/questions/reasoning.json", "reasoning");

    await upload("./question_bank/questions/english.json", "english");

    await upload("./question_bank/questions/quantitative_aptitude.json", "quantitative_aptitude");

    await upload("./question_bank/questions/computer_awareness.json", "computer_awareness");

    await upload("./question_bank/questions/general_awareness.json", "general_awareness");

    console.log("Upload complete");

  } catch (error) {

    console.error("Upload failed:", error);

  }

}

main();