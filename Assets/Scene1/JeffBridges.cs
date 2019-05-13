using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class JeffBridges : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(new Vector3(1, 1, 1));
        transform.Translate(new Vector3(0.01f, 0, 0), Space.World);

        if (Input.GetKeyDown(KeyCode.Space))
            transform.position = new Vector3(-2.5f, 0, 1.7f);

        if (Input.GetKeyDown(KeyCode.RightArrow))
            SceneManager.LoadScene("Part2");
    }
}
