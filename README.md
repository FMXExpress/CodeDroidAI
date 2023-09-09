# CodeDroidAI
Generate code and forms with AI for Delphi Object Pascal using LLMs like ChatGPT and Vicuna-13b.

The CodeDroidAI Desktop client is a powerful UI for generate code and forms for Delphi and C++Builder. Comes with the ability to verify Delphi and C++ code by compiling it and then reporting errors back to ChatGPT. Also supports other LLMs like Vicuna-13b. 
Includes a built in template system to add additional code generation options.

Built in functionality includes:
* Generate Procedures
* Code Analysis
* Comment Code
* Generate A FMX Form
* Convert Delphi Code To Borland C++
* Upgrade Delphi ANSI Code To Unicode
* Generate A VCL Form
* Convert A VCL Form To FMX
* Convert FPC Code To Delphi
* Convert Delphi Code To Inline ASM
* Optimize Code
* Translate Between Languages

Supported models include:
* gpt-3.5-turbo-16k
* gpt-4
* vicuna-13b
* gpt4all
* falcon-40b-instruct
* llama70b-v2-chat
* llama13b-v2-chat
* freewilly2
* fastervicuna_13b
* codellama-13b
* codellama-34b
* wizardcoder-34b
* codellama-7b
* and more!

Built with [Delphi](https://www.embarcadero.com/products/delphi/) using the FireMonkey framework this client works on Windows, macOS, and Linux (and maybe Android+iOS) with a single codebase and single UI. At the moment it is specifically set up for Windows.

It features a REST integration with OpenAI.com (ChatGPT) and Replicate.com for providing source code generation functionality within the client. You need to sign up for API keys to access that functionality. Replicate models can be run in the cloud or locally via docker.

```
docker run -d -p 5000:5000 --gpus=all r8.im/replicate/vicuna-13b@sha256:6282abe6a492de4145d7bb601023762212f9ddbbe78278bd6771c8b3b2f2a13b
curl http://localhost:5000/predictions -X POST -H "Content-Type: application/json" \
  -d '{"input": {
    "prompt": "...",
    "max_length": "...",
    "temperature": "...",
    "top_p": "...",
    "repetition_penalty": "...",
    "seed": "...",
    "debug": "..."
  }}'
```

# CodeDroidAI Desktop client Screenshot on Windows
![CodeDroidAI Desktop client on Windows](/screenshot.png)

Other Delphi AI clients:

[Stable Diffusion Desktop Client](https://github.com/FMXExpress/Stable-Diffusion-Desktop-Client)

[ControlNet Sketch To Image](https://github.com/FMXExpress/ControlNet-Sketch-To-Image)

[AutoBlogAI](https://github.com/FMXExpress/AutoBlogAI)

[AI Code Translator](https://github.com/FMXExpress/AI-Code-Translator)

[AI Playground](https://github.com/FMXExpress/AI-Playground-DesktopClient)

[Song Writer AI](https://github.com/FMXExpress/Song-Writer-AI)

[Stable Diffusion Text To Image Prompts](https://github.com/FMXExpress/Stable-Diffusion-Text-To-Image-Prompts)

[Generative AI Prompts](https://github.com/FMXExpress/Generative-AI-Prompts)

[Dreambooth Desktop Client](https://github.com/FMXExpress/DreamBooth-Desktop-Client)

[Text To Vector Desktop Client](https://github.com/FMXExpress/Text-To-Vector-Desktop-Client)
