import { autocompleteClasses, Box } from "@mui/material";
import React from "react";
import { FormData } from "./lib/types";
import { Input, Button } from "@nextui-org/react";
import { useRouter } from "next/router";
import { handleMint, uploadFile } from "./lib/api";
import Image from "next/image"
import styles from "../styles/Home.module.css";
  
export default function Form() {
    const [message, setMessage] = React.useState("");
    const data: FormData = { form_data: {} };
    const [formState, setFormState] = React.useState(data.form_data);
    const [image, setImage] = React.useState("")
    const router = useRouter();


    async function handle(item)
    {
    await handleMint(item);
    
    setMessage("Minted.")
    }
    
    async function onChange(e) {
     
      
      const file = e.target.files[0];

      const result = await uploadFile(file)
       console.log("result Image", result )
       setImage(result);
       formState.url = result;
    }

    return (
      <div>
        <Box
          display="flex"
          flexDirection="row"
          my={2}
          height="75vh"
          width="100%"
          padding="12px"
          fontSize="0.8rem"
        >
          <Box 
            display="flex"
            flexDirection="column"
            my={2}
            padding="12px"
            >
              <Box my={2}>
            <Input
              size="lg"
              bordered
              labelPlaceholder="Experience Location"
              onChange={(ev) =>
                setFormState({
                  ...formState,
                  ["location"]: ev.target.value,
                })
              }
            />
          </Box>
          <Box my={2}>
            <Input
              size="lg"
              bordered
              labelPlaceholder="Name"
              onChange={(ev) =>
                setFormState({
                  ...formState,
                  ["name"]: ev.target.value,
                })
              }
            />
          </Box>
          <Box my={2}>
          <Input
            size="lg"
            bordered
            labelPlaceholder="Description"
            onChange={(ev) =>
              setFormState({
                ...formState,
                ["description"]: ev.target.value,
              })
            }
          />
        </Box>{" "}
        <Box my={2}>
          <Input
            size="lg"
            bordered
            labelPlaceholder="Price"
            onChange={(ev) =>
              setFormState({
                ...formState,
                ["price"]: ev.target.value,
              })
            }
          />
        </Box>
        <Box>
        <input type="file" name="Asset" className={styles.uploadFileBtn} onChange={onChange } />
        </Box>
        <Box display="flex" justifyContent="center" padding="2vw">
          <Button
            flat
            auto
            rounded
            css={{ color: "green", bg: "#94f9f026" }}
            onPress={() => {
              router.push("/");
            }}
          >
            Go Back
          </Button>
          &nbsp;&nbsp;&nbsp;
          <Button
            flat
            auto
            rounded
            css={{ color: "green", bg: "#94f9f026" }}
            onPress={() => {
              setFormState({
                ...formState,
                ["image"]:image,
              });
                handle(formState);
            }}
          >
            Create Form
          </Button>
        </Box>
          
        </Box>
        <div> 
        {image && <Image src={image} width={200} height={200} layout="fixed"/>}
        </div>
      </Box>
    </div>
  );
}