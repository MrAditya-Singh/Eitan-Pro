const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function generateRecipe(ingredients) {
    const model = genAI.getGenerativeModel({
        model: "gemini-1.5-flash"
    });

    const prompt = `
  You are a professional chef AI.

  Generate a structured JSON recipe using these ingredients:
  ${ingredients}

  Return ONLY valid JSON. Do not include markdown formatting like \`\`\`json.
  
  Structure:
  {
    "title": "Clear and appetizing name",
    "description": "Short, exotic summary",
    "prepTime": number (minutes),
    "cookTime": number (minutes),
    "servings": number,
    "difficulty": "Easy/Medium/Hard",
    "ingredients": [
      {
        "id": "snake_case_id",
        "name": "Full ingredient name",
        "quantity": number,
        "unit": "grams/ml/pieces/etc",
        "category": "protein/produce/dairy/pantry",
        "optional": false
      }
    ],
    "steps": [
      {
        "stepNumber": number,
        "instruction": "Detailed chef instruction",
        "timer": number (minutes, or null),
        "ingredientsUsed": ["id1", "id2"]
      }
    ],
    "nutrition": {
      "calories": number,
      "protein": number,
      "carbs": number,
      "fat": number
    }
  }
  `;

    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    try {
        const cleanText = text.replace(/```json|```/g, "").trim();
        return JSON.parse(cleanText);
    } catch (error) {
        console.error("Failed to parse Gemini JSON:", text);
        throw new Error("Invalid AI Response Format");
    }
}

module.exports = { generateRecipe };
