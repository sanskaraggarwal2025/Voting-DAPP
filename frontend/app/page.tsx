import Image from "next/image";

export default function Home() {
  return (
    <>
      <div className="flex justify-between  rounded-md bg-white bg-opacity-20">
        <div className="p-3 text-4xl font-bold">Vote It!</div>
        <div className="p-3">Sanskar A</div>
        {/* account  */}
      </div>

      <div className="flex justify-center mt-24">
        <div className="flex flex-col items-center justify-center text-center">
          <div className="text-3xl">Vote Without Rigging</div>
          <div className="text-xl pt-3">
            A beauty pageantry is a competition that has traditionally focused
            on judging and ranking the physical...
          </div>
        </div>
      </div>

      <div className="flex justify-center mt-16">
        <div className="flex flex-col items-center justify-center text-center">
          <div className="bg-slate-50 text-black p-4 border rounded-3xl cursor-pointer">
            Create a Poll
          </div>
        </div>
      </div>

      <footer
        className="w-full h-[192px] py-[37px] mt-40
       flex flex-col items-center justify-center
      bg-white bg-opacity-20 px-5"
      >
        <div className="flex justify-center items-center space-x-4">
          <div>LinkedIn</div>
          <div>Youtube</div>
          <div>Github</div>
          <div>Twitter</div>
        </div>

        <hr className="w-full sm:w-[450px] border-t border-gray-400 mt-3" />
        <p className="text-sm font-[500px]">With Love ❤️ by Sanskar </p>
      </footer>
    </>
  );
}
