import { Box } from "@mui/material";
import React from "react";
import { FormData } from "./lib/types";
import { Input, Button } from "@nextui-org/react";
import { useRouter } from "next/router";
import { handleMint } from "./lib/api";

export default function Form() {
    const [message, setMessage] = React.useState("");
    const data: FormData = { form_data: {} };
    const [formState, setFormState] = React.useState(data.form_data);
    const router = useRouter();

    async function handle(item)
    {
    await handleMint(item);
    
    setMessage("Minted.")
    }

    return (
      <div>
        <Box
          display="flex"
          flexDirection="column"
          my={2}
          height="75vh"
          width="75vw"
          padding="12px"
          fontSize="0.8rem"
        >
          <Box my={2}>
            <Input
              size="sm"
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
              size="sm"
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
            size="sm"
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
            size="sm"
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
                handle(formState);
            }}
          >
            Create Form
          </Button>
        </Box>
      </Box>
    </div>
  );
}